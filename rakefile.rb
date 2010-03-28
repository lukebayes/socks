require 'sprout'

############################################
# ActionScript 2 Build Tasks:

namespace :as2 do

  sprout 'as2'

  mtasc 'bin/AS2Client.swf' do |t|
    t.main = true
    t.header = "780:550:24:ffcc00"
    t.input = "as2-src/AS2Client.as"
    t.class_path << 'as2-src'
    t.class_path << 'as2-lib/laml'
  end

  desc "Compile and run the ActionScript 2 client"
  flashplayer :test => 'bin/AS2Client.swf'
end

############################################
# ActionScript 3 Build Tasks:

namespace :as3 do
  sprout 'as3'

  project_model :model do |m|
    m.project_name = 'Socks'
    m.language     = 'as3'
    m.src_dir      = 'as3-src'
    m.test_dir     = 'as3-test'
  end

  desc 'Compile the AS3 Runner'
  mxmlc 'bin/SocksRunner.swf' do |t|
    t.verbose_stacktraces = true
    t.default_size = '900 500'
    t.input = 'as3-src/SocksRunner.as'
    t.library_path << 'as3-lib/asunit4-alpha.swc'
    t.source_path << 'as3-src'
    t.source_path << 'as3-test'
  end

  desc 'Compile run the test harness'
  flashplayer :test => 'bin/SocksRunner.swf'

  desc 'Create documentation'
  document :doc

  desc 'Compile a SWC file'
  compc 'bin/Socks.swc' do |t|
    t.include_sources << 'as3-src'
  end

  # set up the default rake task
  task :default => :test
end

