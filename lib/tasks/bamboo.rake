require 'lib/bamboo'
require 'active-fedora'

namespace :bamboo do

desc 'Ingest TCP files'
task :ingest do
  #adorned_dir = ENV['ADORNED_SOURCE_DIR']
  #unadorned_dir = ENV['UNADORNED_SOURCE_DIR']
  unadorned_dir = "/services/bamboo/TCPFiles/ecco-unadorned"
  adorned_dir = "/services/bamboo/TCPFiles/ecco-adorned-p5simple"

  raise "Define environment variable UNADORNED_SOURCE_DIR" unless unadorned_dir
  raise "Define environment variable ADONRNED_SOURCE_DIR" unless adorned_dir
  
  # If Fedora Repository connection is not already initialized, initialize it using ActiveFedora defaults
  ActiveFedora.init unless Thread.current[:repo]

  ingester = Bamboo::Ingester.new(unadorned_dir, adorned_dir)
  Dir.entries(unadorned_dir).each do |f|
    next if File.directory?(f)
    ingester.ingest(f)
  end
end

task :testit do
  puts "OK"
end

end
