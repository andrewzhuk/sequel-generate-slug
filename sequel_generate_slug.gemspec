require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.required_ruby_version = '>= 2.5.0'
  spec.name                  = 'sequel-generate-slug'
  spec.version               = SequelGenerateSlug::VERSION
  spec.authors               = ['Andrew Zhuk']
  spec.email                 = ['zhuk_andriy@hotmail.com']
  spec.summary               = 'Sequel plugin for generating and maintaining slugs.'
  spec.description           = 'Sequel plugin for generating and maintaining slugs in a database using the base name and an optional additional column.'
  spec.homepage              = 'https://github.com/andrewzhuk/sequel-generate-slug'
  spec.license               = 'MIT'

  spec.files                 = Dir['lib/**/*.rb', 'spec/**/*']
  spec.require_paths         = ['lib']

  spec.add_dependency 'sequel'
  spec.add_dependency 'stringex'

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'

  spec.metadata = {
    'source_code_uri' => 'https://github.com/andrewzhuk/sequel-generate-slug',
    'bug_tracker_uri' => 'https://github.com/andrewzhuk/sequel-generate-slug/issues'
  }
end
