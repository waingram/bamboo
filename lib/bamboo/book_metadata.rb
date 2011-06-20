# defines the expected OM terminology for book item metadata

class Bamboo::BookMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for book metadata
    set_terminology do |t|
      t.root(:path=>"Book", :xmlns => 'info/bamboo', 'xmlns:dc' => "http://dublincore.org/documents/2007/07/02/dcmi-namespace/")
      t.title(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.creator(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.date(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.publisher(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.issued(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.isPartOf(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.isVerionOf(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.identifier(:index_as=>[:searchable, :displayable, :facetable, :sortable], :namespace_prefix => 'dc')
      t.source(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.uri(:index_as=>[:searchable, :displayable, :facetable, :sortable])
  end # set_terminology
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.Book('xmlns' => 'info/bamboo', 'xmlns:dc' => "http://dublincore.org/documents/2007/07/02/dcmi-namespace/") {
        xml['dc'].title
        xml['dc'].creator
        xml['dc'].date
        xml['dc'].publisher
        xml['dc'].issued
        xml['dc'].isPartOf
        xml['dc'].isVersionOf
        xml['dc'].identifier
        xml.source
        xml.uri
      } 
    end
    return builder.doc
  end   

end # class