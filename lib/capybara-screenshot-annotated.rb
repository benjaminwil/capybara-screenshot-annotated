require 'chunky_png'
require 'erb'

module Capybara
  module ScreenshotAnnotated

    def hover_on_link_with_text(text)
      find('a', text: text).hover
    end

    def hover_on_element_with_id(id)
      find("\##{id}").hover
    end

    def save_screenshot
      screenshot = page.save_screenshot
    end

    def save_screenshot_with_filename(filename)
      filename << '.png' unless filename.downcase.include?('.png')
      page.save_screenshot(filename)
    end

    def set_browser_dimensions(width, height)
      @screenshot_dimensions = [width, height]
      page.driver.browser.manage.window.resize_to(width, height)
    end

    def show_cursor(cursor_style = nil)
      cursor_style = "default" if cursor_style == nil
      if available_cursor_styles.include?(cursor_style)
        preferred_cursor = generate_cursor_script(cursor_style)
        execute_script(preferred_cursor)
      else
        raise "The cursor style \"#{cursor_style}\" is not available."
      end
    end

    private

    def crop_screenshot(screenshot, x1, y1, x2, y2)
      canvas = ChunkyPNG::Image.from_file(screenshot)
      cropped_canvas = canvas.crop(9,9,30,30)
      # require 'pry'; binding.pry
      cropped_canvas.save(screenshot)
    end

    def set_crop_size
      if @screenshot_dimensions
        screenshot_width = @screenshot_dimensions[0]
        screenshot_height = @screenshot_dimensions[1]
      end

      x_position = @element_location[0]
      y_position = @element_location[1]

      x_begin = x_position - (full_width / 2)
      y_begin = y_position - (full_width / 2)
      full_width = 700
      full_height = 320

      crop_screenshot(x_begin, y_begin, full_width, full_height)
    end

    def javascripts_directory
      File.join(File.expand_path(File.dirname(__FILE__)), "/javascripts")
    end

    def available_cursor_styles
      ["default", "drag", "pointer", "default-inverted", "drag-inverted", "pointer-inverted"]
    end

    def cursor_style_template(cursor_style)
      File.open("#{javascripts_directory}/cursor/cursor-#{cursor_style}.js.erb", &:read)
    end

    def generate_cursor_script(cursor_style)
      template = cursor_style_template(cursor_style)
      render_cursor_style = ERB.new(template).result(binding)
      cursor_script = File.open("#{javascripts_directory}/cursor/cursor.js.erb", &:read)
      ERB.new(cursor_script).result(binding)
    end

  end
end

require 'capybara'
require 'capybara/dsl'
require 'capybara-screenshot'

require 'capybara-screenshot-annotated/capybara-screenshot.rb'
