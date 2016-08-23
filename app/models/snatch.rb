# -*- encoding : utf-8 -*-
class Snatch < ActiveRecord::Base
  def self.snatch_qq_vip_video(name)
    page = Nokogiri::HTML(open(URI.encode "http://v.qq.com/x/search/?q=#{name}"))
    a = []
    page.css("div[class='_playlist']").first.css("div[class='item']").each do |item|
      next if item.css('span').present? && item.css('span img')[0]['alt'] == '预告'
      a << {name: item.css('a')[0].text.to_i == 0 ? item.css('a')[0].text : "第#{item.css('a')[0].text}集",href: "http://120.25.245.217:8080/homes?url=#{item.css('a')[0]['href']}"}
    end
    page.css("div[class='_playlist']").first.css("div[class='result_btn_line']").each do |item|
      a << {name:  item.css('a')[0].text == '免费试看' ? '免费观看' : item.css('a')[0].text ,href: "http://120.25.245.217:8080/homes?url=#{item.css('a')[0]['href'].gsub('v.qq.com','film.qq.com')}"}
    end
    a
  end
end
