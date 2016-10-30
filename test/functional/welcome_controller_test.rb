require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  test 'should properly show index' do
    # $redis.flushall
    get :index, locale: :en
    assert_response :success
    assert I18n.locale == :en
  end

  test 'should properly load value from yaml' do
    get :index, locale: :en
    assert Lit::LocalizationKey.where(localization_key: 'date.abbr_day_names').exists?
    assert_equal I18n.t('date.abbr_day_names'), %w( Sun Mon Tue Wed Thu Fri Sat )
  end

  test 'should properly store key with default value' do
    get :index, locale: :en
    localization_key = Lit::LocalizationKey.where(localization_key: 'scope.text_with_default').first
    assert localization_key.present?
    locale = Lit::Locale.find_by(locale: :en)
    localization = localization_key.localizations.find_by(locale_id: locale.id)
    assert_equal localization.get_value, 'Default content'
  end
end
