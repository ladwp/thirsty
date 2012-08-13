require 'net/http'
require 'nokogiri'
require 'logger'

module AquaductCrawler

  HOST='wsoweb.ladwp.com'
  BASE_PATH='/Aqueduct/realtime/'
  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def self.site_file_names
    response = Net::HTTP.get(HOST, BASE_PATH)
    body = Nokogiri::HTML(response)
    body.search('pre a').select { |l| l.inner_text.match /^[0-9]+\.htm$/ }.map &:inner_text
  end

  def self.sites
    @sites ||= sites_to_crawl.map do |site_file_name|
      Site.new(site_file_name)
    end
  end

  #exclude sites with wonky data
  def self.sites_to_crawl
    site_file_names - WONKY_SITE_PAGES
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

  # some sites don't have a type specified.
  # Here's my best guess as to what they are. (based on magnitude of value)
  SITE_TO_MEASUREMENT_MAP = {
    "00760" => FLOW,
  }
end

__END__

load 'lib/aquaduct_crawler.rb'
AquaductCrawler.sites.map &:measurements
