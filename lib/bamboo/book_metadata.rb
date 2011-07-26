# defines the expected OM terminology for book item metadata

class Bamboo::BookMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for book metadata
    set_terminology do |t|
      t.root(:path=>"bookMetadata", :xmlns => 'http://library.illinois.edu/schemas/bamboo/bookMetadata')
      t.title(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.creator(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.date(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.publisher(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.issued(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.isPartOf(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.isVerionOf(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.identifier(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.source(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      t.uri(:index_as=>[:searchable, :displayable, :facetable, :sortable])
  end # set_terminology
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.bookMetadata('xmlns' => 'http://library.illinois.edu/schemas/bamboo/bookMetadata') {
        xml.title
        xml.creator
        xml.date
        xml.publisher
        xml.issued
        xml.isPartOf
        xml.isVersionOf
        xml.identifier
        xml.source
        xml.uri
      } 
    end
    return builder.doc
  end   

end # class