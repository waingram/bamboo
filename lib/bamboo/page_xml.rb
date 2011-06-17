require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::PageXML < ActiveFedora::Base
  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'descMetadata', :type => Bamboo::PageMetadata
  has_metadata :name => 'contentMetadata', :type => Bamboo::PageContentMetadata
end
