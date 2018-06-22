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
    
    def crop_screenshot_to_size(width, height)
      x = @element_location.x
      y = @element_location.y
      box = box_measurements(x, y, width, height)
      generate_cropped_screenshot(save_screenshot, box) 
    end

    def save_screenshot
      page.save_screenshot
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

    def generate_cropped_screenshot(screenshot, box_measurements)
      canvas = ChunkyPNG::Image.from_file(screenshot)
      cropped_canvas = canvas.crop(
        box_measurements[:x],
        box_measurements[:y],
        box_measurements[:w],
        box_measurements[:h])
      cropped_canvas.save(screenshot)
    end

    def box_measurements(x_center, y_center, w, h)
      x1 = x_center - (w / 2) 
      y1 = y_center - (h / 2)
        
      x1 = 0 if x1 < 0
      y1 = 0 if y1 < 0
     
      require 'pry'; binding.pry
      { x: x1, y: y1, w: w, h: h }
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
