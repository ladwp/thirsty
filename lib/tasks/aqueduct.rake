namespace "aqueduct" do
  desc "crawl for new samples"
  task :crawl => [:environment] do
    pre_time = Time.now
    pre_count = Sample.count
    AqueductCrawler.update_samples_with_notification
    post_time = Time.now
    post_count = Sample.count
    site_count = Site.count

    puts "there are #{post_count} samples from #{site_count} sites"
    puts "added #{post_count - pre_count} samples in #{post_time - pre_time} seconds"
  end
end
