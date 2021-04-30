require 'pathname'

# copy libraries from `lib` to `lib_lock/ac-library` and add `module AcLibraryRb`
lib_path = File.expand_path('../../lib/**', __FILE__)
lock_dir = File.expand_path('../../lib_lock/ac-library-rb', __FILE__)
Dir.glob(lib_path) do |file|
  next unless FileTest.file?(file)

  path = Pathname.new(lock_dir) + Pathname.new(file).basename
  File.open(path, "w") do |f|
    f.puts "module AcLibraryRb"
    f.puts File.readlines(file).map{ |line| line == "\n" ? "\n" : '  ' + line }
    f.puts "end"
  end
end

# cope library from `lib/core_ext` to `lib_lock/ac-library-rb/core_ext`
lib_path = File.expand_path('../../lib/core_ext/**', __FILE__)
lock_dir = File.expand_path('../../lib_lock/ac-library-rb/core_ext', __FILE__)
Dir.glob(lib_path) do |file|
  next unless FileTest.file?(file)

  path = Pathname.new(lock_dir) + Pathname.new(file).basename
  File.open(path, "w") do |f|
    f.puts File.readlines(file)
  end
end
