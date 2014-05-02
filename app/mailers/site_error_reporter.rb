class SiteErrorReporter < ActionMailer::Base
  def crawler_error(bad_sites)
    return if bad_sites.blank?
    @bad_sites = bad_sites
    mail(to: 'michaeljohnkirk@gmail.com',
      subject: 'Aqueduct crawler errors',
      from: 'ianh.99@gmail.com'
    )
  end
end
