# defines the expected OM terminology for page metadata

class Bamboo::PageMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for content metadata
  set_terminology do |t|
    t.root(:path=>"pageMetadata", :xmlns => 'http://library.illinois.edu/schemas/bamboo/pageMetadata')
    t.seq(:index_as=>[:searchable, :displayable, :facetable, :sortable])
    t.page(:index_as=>[:searchable, :displayable, :facetable, :sortable])
    t.div(:index_as=>[:searchable, :displayable, :facetable, :sortable])
  end # set_terminology
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.pageMetadata('xmlns' => 'http://library.illinois.edu/schemas/bamboo/pageMetadata') {
        xml.seq
        xml.page
        xml.div
      } 
    end
    return builder.doc
  end   

end # class