require 'bundler/setup'
require 'sequel'

require './lib/sequel/plugins/generate_slug'

DB = Sequel.connect('sqlite:/')

RSpec.configure do |config|
  config.order = :random
  Kernel.srand config.seed

  config.pattern = 'spec/**/*_spec.rb'
end
