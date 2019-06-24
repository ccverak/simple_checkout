# frozen_string_literal: true

require "rubygems"
require "bundler"

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  warn e.message
  warn "Run `bundle install` to install missing gems"
  exit e.status_code
end

require "rake"

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

task :environment do
  ENV["RACK_ENV"] ||= "development"
  require File.expand_path("config/environment", __dir__)
end

namespace :db do
  task :environment do
    require File.expand_path("config/environment", __dir__)
  end
end

task routes: :environment do
  Cab::API.routes.each do |route|
    method = route.request_method.ljust(10)
    path   = route.path
    puts "     #{method} #{path}"
  end
end
