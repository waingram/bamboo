require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::TeiXml < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'contentMetadata', :type => Bamboo::ContentMetadata
end
