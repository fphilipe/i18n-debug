require 'i18n'
require 'i18n/debug/version'

module I18n
  module Debug
    @on_lookup = lambda do |key, result|
      logger.debug("[i18n-debug] #{key} => #{result.inspect}")
    end

    class << self
      attr_accessor :logger, :on_lookup

      def logger
        @logger ||=
          if defined?(::Rails)
            ::Rails.logger
          else
            require 'logger'
            ::Logger.new($stdout)
          end
      end
    end

    module Hook
      def self.included(klass)
        klass.class_eval do
          alias_method :lookup_without_debug, :lookup
          alias_method :lookup, :lookup_with_debug
        end
      end

      def lookup_with_debug(*args)
        lookup_without_debug(*args).tap do |result|
          options = args.last.is_a?(Hash) ? args.pop : {}
          separator = options[:separator] || I18n.default_separator
          key = I18n.normalize_keys(*args, separator).join(separator)
          Debug.on_lookup[key, result]
        end
      end
    end
  end

  Backend::Simple.include(Debug::Hook)
end
