# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'date'
require 'pry'

def setup_doc(url)
  charset = 'utf-8'
  html = open(url, &:read)
  Nokogiri::HTML.parse(html, nil, charset)
end

def get_info_list(url)
  info_list = []

  doc = setup_doc(url)
  nodes = doc.xpath('//div[contains(@class, "utileList")][h2]')

  nodes.each do |node|
    info = ''

    title = node.xpath('.//h2/a').text
    info += "#{title}\n"

    p = node.xpath('.//p').text
    schedule = p.gsub(/バラエティー/, '').gsub(/\r\n/, '').gsub(/\n/, '').gsub(/\s+/, '')
    info += schedule

    date = schedule.split('(')[0]
    hour = schedule.split(')')[1].split(':')[0].to_i
    today = Date.today
    m = today.month
    d = today.day
    str_today = "#{m}/#{d}"
    str_tomorrow = "#{m}/#{d + 1}"

    info_list << info if date == str_today || (date == str_tomorrow && hour < 7)
  end

  info_list
end

def get_owarai_list
  url1 = 'https://www.tvkingdom.jp/schedulesBySearch.action?condition.genres%5B0%5D.parentId=105000&condition.genres%5B0%5D.childId=105103&stationPlatformId=1&condition.keyword=&submit=%E6%A4%9C%E7%B4%A2'
  url2 = 'https://www.tvkingdom.jp/s/comedy'
  get_info_list(url1) | get_info_list(url2)
end

owarai_list = get_owarai_list

owarai_list.each do |li|
  if li == owarai_list[-1]
    puts li
  else
    puts "#{li}\n\n"
  end
end
