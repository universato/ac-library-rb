require 'pathname'

# copy libraries from `lib` to `lib_lock/ac-library` and add `module AcLibraryRb`
lib_path = File.expand_path('../lib/**', __dir__)
lock_dir = File.expand_path('../lib_lock/ac-library-rb', __dir__)
Dir.glob(lib_path) do |file|
  next unless FileTest.file?(file)

  path = Pathname.new(lock_dir) + Pathname.new(file).basename
  File.open(path, "w") do |f|
    library_code = File.readlines(file).map{ |line| line == "\n" ? "\n" : '  ' + line }

    f.puts "module AcLibraryRb"
    f.puts library_code
    f.puts "end"
  end
end

# copy library from `lib/core_ext` to `lib_lock/ac-library-rb/core_ext`
ac_library_rb_classes = %w[ModInt FenwickTree PriorityQueue]
replaces = ac_library_rb_classes.to_h{ |cls| ["#{cls}.new", "AcLibraryRb::#{cls}.new"] }
pattern = Regexp.new(replaces.keys.join('|'))

lib_path = File.expand_path('../lib/core_ext/**', __dir__)
lock_dir = File.expand_path('../lib_lock/ac-library-rb/core_ext', __dir__)
Dir.glob(lib_path) do |file|
  next unless FileTest.file?(file)

  path = Pathname.new(lock_dir) + Pathname.new(file).basename
  File.open(path, "w") do |f|
    f.puts File.readlines(file).map{ |text| text.gsub(pattern, replaces) }
  end
end
