# defines the expected OM terminology for book item metadata

class Bamboo::BookMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for book metadata
    set_terminology do |t|
      t.root(:path=>"Item", :xmlns => '', 'xmlns:dc' => "http://dublincore.org/documents/2007/07/02/dcmi-namespace/", 'xmlns:bamboo' => '')
      t.title(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.creator(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.date(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.publisher(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.issued(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.isPartOf(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.isVerionOf(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.identifier(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.source(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'bamboo')
      t.uri(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'bamboo')
  end # set_terminology

end # class