require 'sprout'
# Optionally load gems from a server other than rubyforge:
# set_sources 'http://gems.projectsprouts.org'
sprout 'as3'

############################################
# Configure your Project Model
project_model :model do |m|
  m.project_name            = 'Socks'
  m.language                = 'as3'
end

mxmlc 'bin/SocksRunner.swf' do |t|
  t.default_size = '900 500'
  t.input = 'src/SocksRunner.as'
  t.library_path << 'lib/asunit4-alpha.swc'
  t.source_path << 'src'
  t.source_path << 'test'
end

desc 'Compile run the test harness'
flashplayer :test => 'bin/SocksRunner.swf'

desc 'Create documentation'
document :doc

desc 'Compile a SWC file'
compc 'bin/Socks.swc' do |t|
  t.include_sources << 'src'
end

# set up the default rake task
task :default => :test
