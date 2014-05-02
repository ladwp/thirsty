namespace "aqueduct" do
  desc "crawl for new samples"
  task :crawl => [:environment] do
    pre_time = Time.now
    pre_count = Sample.count
    current_site_samples = {}
    bad_sites = []
    Site.all.each do |site|
      current_site_samples[site.id] = site.samples.count
    end
    AqueductCrawler.update_samples
    current_site_samples.each do |site_id, initial_count|
      site = Site.find(site_id)
      if initial_count == site.samples.count
        bad_sites << site
      end
    end
    unless bad_sites.empty?
      SiteErrorReporter.crawler_error(bad_sites).deliver
    end
    post_time = Time.now
    post_count = Sample.count
    site_count = Site.count

    puts "there are #{post_count} samples from #{site_count} sites"
    puts "added #{post_count - pre_count} samples in #{post_time - pre_time} seconds"
  end
end
