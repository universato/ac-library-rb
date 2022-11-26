require_relative 'lib/ac-library-rb/version'

gem_description = <<~DESCRIPTION
  ac-library-rb is a ruby port of AtCoder Library (ACL).
  DSU(UnionFind), FenwickTree, PriorityQueue, Segtree, SCC, 2-SAT,
  suffix_array, lcp_array, z_algorithm, crt, inv_mod, floor_sum, max_flow, min_cost_flow......
DESCRIPTION

Gem::Specification.new do |spec|
  spec.name          = "ac-library-rb"
  spec.version       = AcLibraryRb::VERSION
  spec.authors       = ["universato"]
  spec.email         = ["universato@gmail.com"]

  spec.summary       = "ac-library-rb is a ruby port of AtCoder Library (ACL)."
  spec.description   = gem_description
  spec.homepage      = "https://github.com/universato/ac-library-rb"
  spec.license       = "CC0"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.7.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/universato/ac-library-rb"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency "prime"

  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency 'simplecov-cobertura'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w[lib_lock lib_helpers"]
end
