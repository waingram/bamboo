require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::TeiText < ActiveFedora::Base

  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'contentMetadata', :type => Bamboo::ContentMetadata
  
  def self.pid_namespace
    'bamboo-cModel'
  end
  
  def self.pid_suffix
    'tei-text'
  end
  
  def initialize(attrs = {})
    super(attrs)
    add_relationship(:has_model, 'info:fedora/bamboo-cModel:cmis-folder')
  end
end
