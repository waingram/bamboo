# defines the expected OM terminology for page metadata

class Bamboo::PageMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for content metadata
    set_terminology do |t|
      t.root(:path=>"pageMetadata", :xmlns => '')
  end # set_terminology

end # class