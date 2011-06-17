require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::Book < ActiveFedora::Base
  has_relationship "parts", :is_part_of, :inbound => true
  
  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'descMetadata', :type => Bamboo::TeiHeader
end
