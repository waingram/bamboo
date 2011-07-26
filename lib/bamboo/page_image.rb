require 'active_fedora'
require 'hydra'
require 'bamboo'

module Bamboo

class PageImage < ActiveFedora::Base

  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'contentMetadata', :type => Bamboo::ContentMetadata
  
  # A place to put extra metadata values
  # has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
  #   m.field 'seq', :string
  #   m.field 'page', :string
  #   m.field 'div', :string
  # end
  has_metadata :name => 'properties', :type => Bamboo::PageMetadata
  
  def self.pid_namespace
    'bamboo-cModel'
  end
  
#  def self.pid_suffix
#    'page'
#  end
  
  def initialize(attrs = {})
    super(attrs)
    add_relationship(:has_model, 'info:fedora/bamboo-cModel:cmis-document')
  end
end

end
