require 'net/http'
require 'nokogiri'
require 'logger'

module AqueductCrawler

  HOST='wsoweb.ladwp.com'
  BASE_PATH='/Aqueduct/realtime/'
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  class ParseError < RuntimeError
  end

  def self.site_parses
    @site_parses ||= sites_to_crawl.first(3).map do |site_file_name|
      begin
        site_parse = SiteParser.new(site_file_name)
        logger.info("Succesfully parsed #{site_file_name}")
      rescue ParseError => e
        logger.error("Failed to parse #{site_file_name} with error: #{e}")
      end
      site_parse
    end.compact
  end

  def self.site_file_names
    Sample.select('distinct site_id').map { |site|
      sprintf("%05d.htm", site.site_id)
    }
  end

  #exclude sites with wonky data
  def self.sites_to_crawl
    site_file_names - WONKY_SITE_PAGES
  end

  def self.update_samples
    site_parses.each do |site_parse|
      logger.debug("parsing site id: #{site_parse.id}")
      site = Site.find_or_create_by_id(site_parse.to_hash)
      site_parse.sample_parses.map do |sample_parse|
        sample_attributes = sample_parse.to_hash.merge({ :site_id => site.id })
        Sample.new(sample_attributes)
      end.each do |sample|
        Sample.find_or_create_by_sampled_at_and_site_id(sample.attributes)
        logger.info("updated sample for site:#{sample.site_id}, sampled_at: #{sample.sampled_at}")
      end
    end
  end

  FLOW = "Flow"
  LEVEL = "Level"
  OUTFLOW = "Outflow"
  TEMP = "Temp"
  ELEVATION = "Elevation"
  INFLOW = "Inflow"

  MEASUREMENT_TYPES = [
    FLOW,
    LEVEL,
    OUTFLOW,
    TEMP,
    ELEVATION,
    INFLOW
  ]

  WONKY_SITE_PAGES = [
    '00760.htm',
    '01210.htm',
    '01630.htm',
    '01650.htm',
    '03540.htm',
    '03560.htm',
    '09990.htm',
    '20660.htm',
    '40700.htm',
    '50450.htm',
    '51150.htm',
    '51150.htm',
    '90030.htm',
    '90110.htm',
    '90120.htm',
    '03530.htm', # a junk row at the begining of the table.
    '32200.htm',
    '32240.htm'
  ]

  # some sites don't have a measurement_type specified.
  # Here's my best guess as to what they are. (based on magnitude of value)
  SITE_TO_MEASUREMENT_MAP = {
    "00760" => FLOW,
  }

  def self.update_samples_with_notification
    current_site_samples = {}
    bad_sites = []
    Site.all.each do |site|
      current_site_samples[site.id] = site.samples.count
    end
    update_samples
    current_site_samples.each do |site_id, initial_count|
      site = Site.find(site_id)
      if initial_count == site.samples.count
        bad_sites << site
      end
    end
    unless bad_sites.empty?
      SiteErrorReporter.crawler_error(bad_sites).deliver
    end

  end
end

