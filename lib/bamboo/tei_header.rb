# defines the expected OM terminology for a TEI Header
require 'active-fedora'

class Bamboo::TeiHeader < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for the tei header xml
  set_terminology do |t|
    t.root(:path=>"teiHeader", :xmlns=>"")
    

  end # set_terminology

end # class