# frozen_string_literal: true

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by(:rack_test)
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium, using: :headless_chrome do |driver_option|
      driver_option.add_argument('headless=new')
    end
  end
end
