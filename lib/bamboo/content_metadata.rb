# defines the expected OM terminology for content metadata

class Bamboo::ContentMetadata < ActiveFedora::NokogiriDatastream 
   
  # OM (Opinionated Metadata) terminology mapping for content metadata
    set_terminology do |t|
      t.root(:path=>"imagePageContentMetadata", :xmlns => '')

  # these are attributes on contentMetadata element ...    
  #    t.type
  #    t.object_id(:xpath=>"@objectId", :index_as=>[:searchable, :displayable])
  #    t.object_id(:attributes=>{:type=>"objectId"}, :index_as=>[:searchable, :displayable])
      t.resource {
  # these are attributes on resource element      
  #      t.id
  #      t.type
  #      t.data
  #      t.object_id
        t.file {
  # these are attributes on file elements
  #        t.id(:path=>"@id", :index_as=>[:searchable, :displayable])
  #        t.format
  #        t.mime(:xpath=>"@mimetype", :index_as=>[:displayable, :facetable])
  #        t.size
  #        t.preserve(:xpath=>"//file@preserve", :index_as=>[:displayable, :facetable])
  #        t.shelve(:xpath=>"//file@shelve", :index_as=>[:displayable, :facetable])
  #        t.deliver(:xpath=>"//file@display", :index_as=>[:displayable, :facetable])

          t.location(:path=>"location", :attributes=>{:type=>"url"}, :index_as=>[:displayable])
          t.checksum_md5(:path=>"checksum", :attributes=>{:type=>"md5"}, :index_as=>[:displayable])
          t.checksum_sha1(:path=>"checksum", :attributes=>{:type=>"sha1"}, :index_as=>[:displayable])
        }
      }

      # proxy declarations
  #    t.file_id(:proxy=>[:resource, :file, :id])
  #    t.file_mime(:proxy=>[:resource, :file, :mime])
      t.file_location(:proxy=>[:resource, :file, :location])
  end # set_terminology

end # class