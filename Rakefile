require 'rubygems' unless ENV['NO_RUBYGEMS']
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require 'spec/rake/spectask'
require 'lib/teamcity-client'

spec = Gem::Specification.new do |s|
  s.name = "teamcity-client"
  s.version = TeamCityClient.version
  s.author = "Stephen McDonald"
  s.email = "steve@jupo.org"
  s.homepage = "http://jupo.org"
  s.description = s.summary = "Team City HTTP client."
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE", 'TODO']
  s.add_dependency "nokogiri"
  s.add_dependency "rest-client"
  s.executables = [s.name]
  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc Rakefile TODO) + Dir.glob("{lib,spec,bin}/**/*")
end

task :default => :spec

desc "Run specs"
Spec::Rake::SpecTask.new do |t|
  t.spec_files = FileList['spec/**/*_spec.rb']
  t.spec_opts = %w(-fs --color)
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end
