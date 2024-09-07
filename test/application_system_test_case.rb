require "test_helper"
require "capybara/cuprite"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  include ActionView::RecordIdentifier

  TOM_SELECT_CONTROL_SELECTOR = ".ts-control"
  TOM_SELECT_INPUT_SELECTOR = "#{TOM_SELECT_CONTROL_SELECTOR} input"
  TOM_SELECT_OPTION_SELECTOR = ".ts-dropdown .ts-dropdown-content .option"

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

  driven_by :anno_cuprite

  # Ensure 404 bring up error pages
  Rails.application.config.action_dispatch.show_exceptions = :all

  def fill_in_tom_select_field(value)
    assert_selector(TOM_SELECT_CONTROL_SELECTOR, count: 1)

    find(TOM_SELECT_CONTROL_SELECTOR).click

    assert_selector(".ts-dropdown", count: 1)

    text_option_regex = /^#{Regexp.quote(value)}$/i
    find(TOM_SELECT_CONTROL_SELECTOR).send_keys(:backspace, value)

    assert_selector TOM_SELECT_OPTION_SELECTOR, text: text_option_regex, count: 1

    find(TOM_SELECT_OPTION_SELECTOR, text: text_option_regex).click

    within ".ts-control" do
      assert_text value
    end

    current_page_context = "document.evaluate(\"#{current_scope.path}\", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue"
    page.execute_script %{#{current_page_context}.querySelector('#{TOM_SELECT_INPUT_SELECTOR}').blur() }

    assert_no_selector ".ts-dropdown", text: value, count: 1
  end
end
