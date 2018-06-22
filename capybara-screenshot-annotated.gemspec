Gem::Specification.new do |s|
  s.name = 'capybara-screenshot-annotated'
  s.version = '0.0.0'
  s.date = '2018-06-19'
  s.summary = "Annotated website screenshots"
  s.description = "Create annotated screenshots with Capybara."
  s.authors = ["Benjamin Willems"]
  s.email = 'bw@benjaminwil.info'
  s.files = ["lib/capybara-screenshot-annotated.rb"]
  s.homepage = 'https://github.com/benjaminwil/capybara-screenshot-annotated'
  s.license = 'MIT'
  
  s.add_dependency 'capybara'
  s.add_dependency 'capybara-screenshot'
  s.add_dependency 'chunky_png'
  s.add_dependency 'minitest'
  s.add_dependency 'rspec'
  s.add_dependency 'selenium-webdriver'
end


