require_relative 'lib/i18n/debug/version'

Gem::Specification.new do |spec|
  spec.name        = 'i18n-debug'
  spec.version     = I18n::Debug::VERSION
  spec.author      = 'Philipe Fatio'
  spec.email       = 'me@phili.pe'
  spec.homepage    = 'https://github.com/fphilipe/i18n-debug'
  spec.license     = 'MIT'
  spec.files       = `git ls-files -z`.split("\x0")
  spec.test_files  = `git ls-files -z -- test`.split("\x0")
  spec.summary     = %q{Ever wondered which translations are being looked up by Rails, a gem, or simply your app? Wonder no more!}
  spec.description = spec.summary

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.8'
  spec.add_dependency 'i18n', '< 1'
end
