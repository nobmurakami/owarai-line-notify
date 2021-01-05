# frozen_string_literal: true

require 'line_notify'
require './owarai_info'

line_notify = LineNotify.new(ENV['LINE_NOTIFY_TOKEN'])

message = "\n"

owarai_list = get_owarai_list
owarai_list.each do |li|
  message += if li == owarai_list[-1]
               li
             else
               "#{li}\n\n"
             end
end

options = { message: message }

line_notify.ping(options)
