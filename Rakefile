task :default => :test

# @todo restore the clang analyze task, don't forget to add rubyhdrdir

desc 'Startup an IRb console with accessibility_keyboard loaded'
task :console => :compile do
  sh 'irb -Ilib -raccessibility/keyboard'
end

# Gem stuff

require 'rubygems/package_task'
SPEC = Gem::Specification.load('accessibility_keyboard.gemspec')

Gem::PackageTask.new(SPEC) { }

desc 'Build and install gem (not including deps)'
task :install => :gem do
  require 'rubygems/installer'
  Gem::Installer.new("pkg/#{SPEC.file_name}").install
end

desc 'Run tests'
task :test => :compile do
  files = FileList['test/**/*_test.rb']
  sh "test/runner #{files}"
end

require 'rake/extensiontask'
Rake::ExtensionTask.new('key_coder', SPEC) do |t|
  t.lib_dir = 'lib/accessibility'
end
