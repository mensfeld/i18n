$:.unshift 'lib/i18n/lib'

require 'rubygems'
require 'mocha'

require 'test/unit'
require 'active_support'

require 'i18n'
require 'i18n/backend/simple'
I18n.backend = I18n::Backend::Simple
require 'i18n/backend/translations'

gem 'mocha', '>=0.5'

class LocaleTest < Test::Unit::TestCase
  def setup  
    @locale = Locale.current
  end
  
  def test_translate_given_a_translation_key_it_inserts_itself_to_localization_args
    I18n.backend = mock  
    I18n.backend.expects(:translate).with(:locale => Locale['en-US'], :keys => [:currency])
    @locale.t :currency
  end
  
  def test_translate_given_a_translation_key_and_options_it_inserts_itself_to_localization_args
    I18n.backend = mock  
    I18n.backend.expects(:translate).with(:locale => Locale['en-US'], :keys => [:currency, :format, :precision])
    @locale.t :precision, :scope => 'currency.format'
  end
  
  def test_translate_given_a_translation_key_locale_and_options_it_replaces_the_locale_in_localization_args
    I18n.backend = mock  
    I18n.backend.expects(:translate).with(:locale => Locale['en-US'], :keys => [:currency, :format, :precision])
    @locale.t :precision, Locale['de-DE'], :scope => 'currency.format'
  end
  
  def test_locale_with_options_using_scope_works
    I18n.backend.expects(:translate).with(:locale => Locale['en-US'], :keys => [:currency, :format, :precision])
    @locale.with_options :scope => 'currency.format' do |locale|
      locale.t :precision
    end
  end
end