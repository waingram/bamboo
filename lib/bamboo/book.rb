require 'active_fedora'
require 'hydra'
require 'bamboo'

class Bamboo::Book < ActiveFedora::Base
  include Hydra::ModelMethods
  
  has_relationship "parts", :is_part_of, :inbound => true
  
  has_metadata :name => 'rightsMetadata', :type => Hydra::RightsMetadata
  has_metadata :name => 'descMetadata', :type => Bamboo::TeiHeader
  
  # A place to put extra metadata values
  has_metadata :name => "properties", :type => ActiveFedora::MetadataDatastream do |m|
    m.field 'root', :string
    m.field 'title', :string
    m.field 'creator', :string
    m.field 'date', :string
    m.field 'publisher', :string
    m.field 'issued', :string
    m.field 'isPartOf', :string
    m.field 'isVersionOf', :string
    m.field 'identifier', :string
    m.field 'source', :string
    m.field 'uri', :string
  end
  
  def self.pid_namespace
    'bamboo-cModel'
  end
  
  def self.pid_suffix
    'book'
  end
  
  def initialize(attrs = {})
    super(attrs)
    add_relationship(:has_model, 'info:fedora/bamboo-cModel:cmis-folder')
  end
end
