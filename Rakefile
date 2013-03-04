require "bundler"
Bundler.setup

require "rspec/core/rake_task"
Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read("rails_reroute.gemspec"))

task :build => "#{gemspec.full_name}.gem"

file "#{gemspec.full_name}.gem" => gemspec.files + ["rails_reroute.gemspec"] do
  system "gem build rails_reroute.gemspec"
  system "gem install rails_reroute-0.1.gem"
end
