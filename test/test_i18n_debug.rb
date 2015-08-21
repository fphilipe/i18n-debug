$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'i18n/debug'
require 'minitest/autorun'

class TestI18nDebug < Minitest::Test
  alias_method :silence_io, :capture_io

  def setup
    I18n.backend.store_translations(:en, foo: { bar: 'baz' })
    # Avoid I18n deprecation warning:
    I18n.enforce_available_locales = true
    # Reset logger to its initial state:
    I18n::Debug.logger = nil
  end

  def test_does_not_alter_default_i18n_behavior
    silence_io do
      assert_equal I18n.t('foo.bar'), 'baz'
    end
  end

  def test_logger_invoked
    assert_output(/en\.foo\.bar => "baz"/) do
      I18n.t('foo.bar')
    end
  end

  def test_custom_lookup_hook_called
    default_hook = I18n::Debug.on_lookup
    hook_key, hook_value = nil
    I18n::Debug.on_lookup do |key, value|
      hook_key, hook_value = key, value
    end

    I18n.t('foo.bar')

    assert_equal hook_key, 'en.foo.bar'
    assert_equal hook_value, 'baz'
  ensure
    I18n::Debug.on_lookup = default_hook
  end
end
