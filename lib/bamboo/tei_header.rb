# defines the expected OM terminology for a TEI Header
require 'active-fedora'

class Bamboo::TeiHeader < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for the tei header xml
  set_terminology do |t|
    t.root(:path=>"teiHeader", :xmlns=>"http://www.tei-c.org/ns/1.0")
    t.fileDesc {
      t.titleStmt {
        t.title(:index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.author(:index_as=>[:searchable, :displayable, :facetable, :sortable])
      }
      t.extent
      t.publicationStmt {
        t.publisher(:index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.pubPlace(:index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.date(:index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.DPLS(:path=>"idno", :attributes=>{:type=>"DPLS"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.ESTC(:path=>"idno", :attributes=>{:type=>"ESTC"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.DocNo(:path=>"idno", :attributes=>{:type=>"DocNo"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.TCP(:path=>"idno", :attributes=>{:type=>"TCP"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.GaleDocNo(:path=>"idno", :attributes=>{:type=>"GaleDocNo"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.ContentSet(:path=>"idno", :attributes=>{:type=>"ContentSet"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.ImageSetID(:path=>"idno", :attributes=>{:type=>"ImageSetID"}, :index_as=>[:searchable, :displayable, :facetable, :sortable])
        t.availability
      }
    }

  end # set_terminology

end # class