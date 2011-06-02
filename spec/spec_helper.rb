#This file is for code to help conduct spec tests
require 'rspec'

#Add root directory to load path
$: <<  File.join(File.dirname(__FILE__), '../lib')
PROJECT_ROOT = File.join(File.dirname(__FILE__), '../')