require 'capybara'
require 'capybara/dsl'
require 'capybara-screenshot'


module Capybara
  module ScreenshotAnnotated

    def create_cursor(input)
      dir = File.expand_path File.dirname(__FILE__)
      cursor = File.open("#{dir}/cursor/cursor-#{input}.js")
      
      beginning = File.open("#{dir}/cursor/begin.js")
      ending = File.open("#{dir}/cursor/end.js")
      output = String.new

      [beginning, cursor, ending].each do |file|
        file.each_line do |line|
          output += line
        end
      end

      execute_script(output) 
    end
    
    def hover_on_link(text)
      find('a', text: text).hover
    end
  end
end

require 'capybara-screenshot-annotated/capybara-screenshot.rb'
