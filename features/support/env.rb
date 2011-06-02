#global set up for cucumber tests
$: << File.join(File.dirname(__FILE__), '../../lib')
PROJECT_ROOT = File.join(File.dirname(__FILE__), '../../')

#require needed files
require 'spec/expectations'
require 'bamboo'
