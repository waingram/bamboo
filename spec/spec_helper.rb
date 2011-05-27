#This file is for code to help conduct spec tests
require 'rspec'

#Add root directory to load path
PROJECT_ROOT =  File.join(File.dirname(__FILE__), '..')
$LOAD_PATH.unshift PROJECT_ROOT