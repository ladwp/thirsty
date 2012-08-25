module ApplicationHelper
  def usable_time(time)
    time_string = if (Time.now - time).abs < 10.days
      time_ago_in_words(time) + " ago"
    else
      time.to_s(:long)
    end

    "<abbr class='datetime' title='#{time}'>#{time_string}</abbr>".html_safe
  end
end
