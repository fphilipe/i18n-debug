# Ruby I18n Debug

[![Build Status][build-image]][build-link]
[![Gem Version][gem-image]][gem-link]

**Ever wondered which translations are being looked up by Rails, a gem, or
simply your app? Wonder no more!**

Rails' implicit translations, for instance, are a nice feature. But sometimes
getting the key to, let's say, the `BillingAddress`' `street` attribute in
a nested form inside an `Order` can be quite tricky to get right on the first
try. The key for this example would be
`activerecord.attributes.order/billing_address.street`. Good luck figuring that
out!

With this gem you can easily see which translations are being looked up. The key
above would have created the following debug log entry:

```
[i18n-debug] activerecord.attributes.order/billing_address.name => nil
```

After setting the translation for that key you just discovered, the log entry
changes to this:

```
[i18n-debug] activerecord.attributes.order/billing_address.name => "Order billing name"
```

## Installation

Simply add the gem to your `Gemfile`. You probably only want this in development.
Thus, place it inside the `development` group.

```ruby
gem 'i18n-debug', group: :development
```

If you need support for ruby <= 2.0, make sure to use version 1.0.0.

## Usage

This gem works straight out of the box. If Rails is available, it will log using
`Rails.logger.debug`. Otherwise it will log using `Logger.new($stdout).debug`.

If you wish to use a custom logger, simply set it as follows (make sure it
responds to `debug`):

```ruby
I18n::Debug.logger = my_custom_logger
```

Every lookup invokes the lambda `I18n::Debug.on_lookup` with the key and the
translation value as arguments. The default lambda simply logs it to the logger
mentioned above. If you want to change the logging format or do something
totally different, simply set your own handler to do so:

```ruby
# Collect stats on I18n key usage.
i18n_stats = Hash.new { |stats, key| stats[key] = 0 }

I18n::Debug.on_lookup do |key, value|
  i18n_stats[key] += 1 if value
end
```

## Additional Information

This gem was inspired by a similar gem called
[rails-i18n-debug](https://github.com/256dpi/rails-i18n-debug).

### Dependencies

- [i18n](https://github.com/svenfuchs/i18n)

### Author

Philipe Fatio ([fphilipe](https://github.com/fphilipe))

### License

MIT License. Copyright 2014 Philipe Fatio

[build-image]: https://travis-ci.org/fphilipe/i18n-debug.svg
[build-link]:  https://travis-ci.org/fphilipe/i18n-debug
[gem-image]:   https://badge.fury.io/rb/i18n-debug.svg
[gem-link]:    https://rubygems.org/gems/i18n-debug
