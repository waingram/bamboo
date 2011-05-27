#global set up for cucumber tests

PROJECT_ROOT =  File.join(File.dirname(__FILE__), '../..')
#make sure top level directory is on the load path
$LOAD_PATH.unshift PROJECT_ROOT

#require needed files
require 'rspec/expectations'
