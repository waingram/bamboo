require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::Book < ActiveFedora::Base
  has_relationship "parts", :is_part_of, :inbound => true
  
  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'teiHeader', :type => Bamboo::TeiHeader
  has_metadata :name => 'descMetadata', :type => Bamboo::BookMetadata
  
  def self.pid_namespace
    'bamboo-cModel'
  end
  
  def self.pid_suffix
    'book'
  end
  
  def initialize( attrs={} )
    super
  end
end
