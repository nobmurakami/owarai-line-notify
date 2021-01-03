require 'nokogiri'
require 'open-uri'
require "date"
require 'pry'

def setup_doc(url)
  charset = 'utf-8'
  html = open(url) { |f| f.read }
  doc = Nokogiri::HTML.parse(html, nil, charset)
  # doc.search('br').each { |n| n.replace("\n") }
  doc
end

def get_owarai_list
  info_list = []

  url = 'https://www.tvkingdom.jp/schedulesBySearch.action?condition.genres%5B0%5D.parentId=105000&condition.genres%5B0%5D.childId=105103&stationPlatformId=1&condition.keyword=&submit=%E6%A4%9C%E7%B4%A2'
  doc = setup_doc(url)
  nodes = doc.xpath('//div[contains(@class, "utileList")][h2]')

  nodes.each do |node|
    info = ""

    title = node.xpath('.//h2/a').text
    info += title + "\n"

    p = node.xpath('.//p').text
    schedule = p.gsub(/バラエティー/, '').gsub(/\r\n/, '').gsub(/\n/, '').gsub(/          /, '').gsub(/  /, '').gsub(/  /, '').gsub(/  /, '')
    info += schedule

    date = schedule.split()[0]
    today = Date.today
    m = today.month
    d = today.day
    str_today = "#{m.to_s}/#{d.to_s}"

    if date == str_today
      info_list << info
    end
  end

  return info_list
end

owarai_list = get_owarai_list

owarai_list.each do |li|
  if li == owarai_list[-1]
    puts li
  else
    puts li + "\n\n"
  end
end

