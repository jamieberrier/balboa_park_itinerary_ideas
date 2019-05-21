
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "balboa_park_itinerary_ideas/version"

Gem::Specification.new do |spec|
  spec.name          = "balboa_park_itinerary_ideas"
  spec.version       = BalboaParkItineraryIdeas::VERSION
  spec.authors       = ["'jamieberrier'"]
  spec.email         = ["'berrier.jamie@gmail.com'"]

  spec.summary       = "Balboa Park Itinerary Ideas"
  spec.description   = "A Ruby Gem providing a CLI to view itinerary ideas for San Diego's Balboa Park as per the Balboa Park website."
  spec.homepage      = "https://rubygems.org/gems/balboa_park_itinerary_ideas"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/jamieberrier/balboa_park_itinerary_ideas"
    spec.metadata["changelog_uri"] = "https://github.com/jamieberrier/balboa_park_itinerary_ideas"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry", ">= 0"

  spec.add_dependency "nokogiri", "~> 1.10", ">= 1.10.3"
  spec.add_dependency "colorize", "~> 0.8.1"
  spec.add_dependency "strings", "~> 0.1.4"
end
