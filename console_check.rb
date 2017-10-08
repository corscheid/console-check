require 'selenium-webdriver'

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
    # skip the line if it's a malformed URL
    if test_url !~ /^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$/ix
      puts "[INVALID URL] : #{test_url}"
      next
    end

    @driver.navigate.to test_url

    # print out js console errors
    puts test_url
    80.times { print '-' }
    puts
    sleep(2) # time for page loads
    errs = @driver.manage.logs.get :browser
    puts errs.empty? ? 'NO JS CONSOLE ERRORS' : errs
    80.times { print '-' }
    puts
  end # foreach
end # def

run { url_data 'urls.txt' }
