# defines the expected OM terminology for a TEI Header
require 'active-fedora'

class Bamboo::TeiHeader < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for the tei header xml
  set_terminology do |t|
    t.root(:path=>"teiHeader", :xmlns=>"")
    t.fileDesc {
      t.titleStmt {
        t.title(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      }
    }
    t.book_title(:proxy=>[:fileDesc, :titleStmt, :title])

  end # set_terminology

  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.teiHeader{
        
      }
    end
    return builder.doc
  end

end # class