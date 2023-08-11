require "test_helper"
require "capybara-screenshot/minitest"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::RecordIdentifier
  include Capybara::Screenshot::MiniTestPlugin

  # https://github.com/rubycdp/cuprite/issues/180#issuecomment-1004943531
  Capybara.register_driver(:anno_cuprite) do |app|
    Capybara::Cuprite::Driver.new(
      app,
      browser_options: {
        "disable-dev-shm-usage": nil,
        "no-sandbox": nil
      },
      headless: true,
      window_size: [1400, 1400]
    )
  end

  Capybara::Screenshot.register_driver(:anno_cuprite) do |driver, path|
    driver.save_screenshot(path)
  end

  driven_by :anno_cuprite

  # Ensure 404 bring up error pages
  Rails.application.config.action_dispatch.show_exceptions = true

  def fill_in_tom_select_field(container, value)
    within(container, match: :first) do
      find(".ts-control").click

      input_control = find(".ts-control input")
      input_control.native.clear
      input_control.send_keys(value)
    end

    all(".ts-dropdown .ts-dropdown-content .option", text: /#{Regexp.quote(value)}/i)[0].click
  end
end
