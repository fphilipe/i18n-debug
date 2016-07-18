require 'i18n'
require 'i18n/debug/version'

module I18n
  module Debug
    ON_LOOKUP_DEFAULT = lambda do |key, result|
      logger.debug("[i18n-debug] #{key} => #{result.inspect}")
    end

    class << self
      attr_accessor :logger

      def logger
        @logger ||=
          if defined?(::Rails)
            ::Rails.logger
          else
            require 'logger'
            ::Logger.new($stdout)
          end
      end

      def on_lookup(&blk)
        if block_given?
          Thread.current[:i18n_debug_on_lookup] = blk
        else
          Thread.current[:i18n_debug_on_lookup] || ON_LOOKUP_DEFAULT
        end
      end

      def on_lookup=(blk)
        Thread.current[:i18n_debug_on_lookup] = blk
      end
    end

    module Hook
      def lookup(*args)
        super.tap do |result|
          options = args.last.is_a?(Hash) ? args.pop : {}
          separator = options[:separator] || I18n.default_separator
          key = I18n.normalize_keys(*args, separator).join(separator)
          Debug.on_lookup[key, result]
        end
      end
    end
  end

  Backend::Simple.prepend(Debug::Hook)
end
