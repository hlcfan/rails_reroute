require "bundler"
Bundler.setup

require "rspec/core/rake_task"
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("rails-reroute.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rails-reroute.gemspec"] do
  system "gem build rails-reroute.gemspec"
  system "gem install rails-reroute-0.1.gem"
end
