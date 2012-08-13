namespace "aquaduct" do
  desc "crawl for new samples"
  task :crawl => [:environment] do
    pre_time = Time.now
    pre_count = AquaductCrawler::Sample.count
    AquaductCrawler.update_samples
    post_time = Time.now
    post_count = AquaductCrawler::Sample.count
    site_count = AquaductCrawler::Site.count

    puts "there are #{post_count} samples from #{site_count} sites"
    puts "added #{post_count - pre_count} samples in #{post_time - pre_time} seconds"
  end
end
