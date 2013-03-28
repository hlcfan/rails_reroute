Gem::Specification.new do |s|
  s.name = "rails_reroute"
  s.version = "0.2.2"

  s.authors     = ["Nathaniel Barnes"]
  s.email       = ["Nathaniel.R.Barnes@gmail.com"]
  s.homepage    = "http://github.com/NateBarnes/rails_reroute"
  s.summary     = "Reroute rails requests fully"
  s.description = s.summary
  s.rubyforge_project = "rails_reroute"

  s.files         = `git ls-files`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
