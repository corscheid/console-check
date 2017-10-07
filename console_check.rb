require 'selenium-webdriver'
# require 'open-uri'

def setup
  @driver = Selenium::WebDriver.for :chrome
end

def teardown
  @driver.quit
end

def run
  setup
  yield
  teardown
end

def url_data(url_filename)
  File.foreach(url_filename) do |test_url|
    # skip the line if it's a malformed URL TODO: gather these and report them
    if test_url !~ /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
      puts '[INVALID URL]'
      next
    end # if
    @driver.navigate.to test_url
    # print out js console errors
    puts test_url
    80.times { print '-' }
    puts
    sleep(1)
    errs = @driver.manage.logs.get :browser
    puts errs.empty? ? 'NO JS CONSOLE ERRORS' : errs
    80.times { print '-' }
    puts
  end # each
end # def

run { url_data 'urls.txt' }
