# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capistrano-variables-namespaces-list"
  s.version     = "0.9.9"
  s.authors     = ["Ewout Vonk"]
  s.email       = ["dev@ewout.to"]
  s.homepage    = "https://github.com/ewoutvonk/capistrano-variables-namespaces-list"
  s.summary     = %q{extensions which adds a list to capistrano which maintains in which namespace a variable was first set}
  s.description = %q{extensions which adds a list to capistrano which maintains in which namespace a variable was first set}

  s.rubyforge_project = "capistrano-variables-namespaces-list"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "capistrano"
end
