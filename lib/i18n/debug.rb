require 'i18n'
require 'i18n/debug/version'

module I18n
  module Debug
    @on_lookup = lambda do |key, result|
      logger.debug("[i18n-debug] #{key} => #{result.inspect}")
    end

    class << self
      attr_accessor :logger
      attr_writer :on_lookup

      def logger
        @logger ||=
          if defined?(::Rails) and ::Rails.respond_to?(:logger)
            ::Rails.logger
          else
            require 'logger'
            ::Logger.new($stdout)
          end
      end

      def on_lookup(&blk)
        return @on_lookup unless block_given?
        self.on_lookup = blk
      end
    end

    module Hook
      protected

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
