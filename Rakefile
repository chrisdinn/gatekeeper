require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "gatekeeper"
    gem.summary = "Connects any Rack-compatible app to a Hot Ink single sign on server."
    gem.description = "Connects any Rack-compatible app to a Hot Ink single sign on server."
    gem.email = "chrisgdinn@gmail.com"
    gem.homepage = "http://github.com/chrisdinn/gatekeeper"
    gem.authors = ["Chris Dinn"]
    gem.add_dependency 'ruby-openid', '>= 2.1.7'
    gem.add_dependency 'rack-openid', '>= 0.2.1'
    gem.add_dependency 'sinatra', '>= 0.9.2'
    gem.add_development_dependency "rspec", ">= 1.2.9"
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :spec => :check_dependencies

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "gatekeeper #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
