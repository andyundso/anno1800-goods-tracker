require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::RecordIdentifier

  Capybara.register_driver :headless_chromium do |app|
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--window-size=1400,1400")
    Capybara::Selenium::Driver.new(app, browser: :chrome, capabilities: options)
  end

  driven_by :headless_chromium

  # Ensure 404 bring up error pages
  Rails.application.config.action_dispatch.show_exceptions = true
end
