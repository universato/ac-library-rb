begin
  require 'simplecov'
  SimpleCov.start
  if ENV['GITHUB_ACTIONS'] == 'true'
    require 'simplecov-cobertura'
    SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
  end
rescue LoadError
  puts "[INFO] You can use simplecov gem for this test!"
end

require_relative 'convolution_test'
require_relative 'crt_test'
require_relative 'deque_test'
require_relative 'dsu_test'
require_relative 'fenwick_tree_test'
require_relative 'floor_sum_test'
require_relative 'inv_mod_test'
require_relative 'lazy_segtree_test'
require_relative 'lcp_array_test'
require_relative 'max_flow_test'
require_relative 'min_cost_flow_test'
require_relative 'modint_test'
require_relative 'pow_mod_test'
require_relative 'priority_queue_test'
require_relative 'scc_test'
require_relative 'segtree_test'
require_relative 'suffix_array_test'
require_relative 'two_sat_test'
require_relative 'z_algorithm_test'

require_relative "../lib/ac-library-rb/version"
class AcLibraryRbTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::AcLibraryRb::VERSION
  end
end
