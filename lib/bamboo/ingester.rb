

class Bamboo::Ingester
  attr_accessor :unadorned_path
  attr_accessor :adorned_path

  def initialize(unadorned_path, adorned_path)
    @unadorned_path = unadorned_path
    @adorned_path = adorned_path
  end
  
  def load_tei(tei_filename)
    begin
      raise ArgumentError, "[ERROR] load_tei: #{File.join(@unadorned_path, tei_filename)} does not exist" unless File.exists? File.join(@unadorned_path, tei_filename)
      raise InvalidFormat, "[ERROR] load_tei: #{File.join(@unadorned_path, tei_filename)} is not XML" unless File.extname(File.join(@unadorned_path, tei_filename)) == '.xml'
      @tei_filename   = tei_filename
      @tei_xml        = Nokogiri::XML::Document.parse(File.read(File.join(@unadorned_path, @tei_filename)))
      @pid            = tcpid_to_pid
    rescue
      raise
    end
  end
  
  def image_urls
    pbs   = @tei_xml.css("pb")
    urls = Array.new
    
    pbs.each do |pb|
      n = pb['n']
      facs = pb['facs']
      #image_url = gale_url(facs, n)
      image_url = michigan_url(facs, n)

      urls << image_url
    end
    urls
  end
    

  def ingest(tei_filename)
    begin
      load_tei(tei_filename)
      book = create_book
      tei = create_tei_object
      morph_adorned = create_morph_adorned_object
      pages = create_page_image_objects
      @pid
    rescue Exception => e
      puts e.message
      puts e.backtrace
    end
  end

  def create_book
    begin
      replacing_object(@pid) do
        book = Bamboo::Book.new(:pid => @pid)
        #TEI header ds
        tei_header_ds                      = book.datastreams['descMetadata']
        tei_header_ds.ng_xml               = Nokogiri::XML::Document.new
        tei_header_ds.ng_xml               << tei_header_xml.to_xml
        tei_header_ds.attributes[:dsLabel] = "TEI Header"
        book.label = title
        book.save
        #PROPS
        props = book.datastreams['properties']
        props.title_values << tei_header_ds.term_values(:fileDesc, :titleStmt, :title).first
        props.creator_values << tei_header_ds.term_values(:fileDesc, :titleStmt, :author).first
        props.date_values << tei_header_ds.term_values(:fileDesc, :publicationStmt, :date).first
        props.publisher_values << tei_header_ds.term_values(:fileDesc, :publicationStmt, :publisher).first
        props.issued_values << tei_header_ds.term_values(:fileDesc, :publicationStmt, :date).first
        props.identifier_values << "http//ramman.grainger.uiuc.edu/fedora/objects/#{@pid}"
        props.source_values << "http://www.lib.umich.edu/tcp/ecco"
        props.uri_values << @tei_filename
        props.save
        #RELS
        
        book.save
        return book
      end
    rescue Exception => e
      raise "[ERROR] create_book: #{e.message}"
      #puts e.backtrace
    end

  end

  def create_tei_object
    pid = @pid + ".tei"
    begin
      replacing_object(pid) do
        tei_obj = Bamboo::TeiText.new(:pid=>pid)
        #TEI ds
        tei_path = File.join(@unadorned_path, @tei_filename)
        tei_ds = ActiveFedora::Datastream.new(:dsLabel => "TEI XML", :controlGroup => "M", :blob =>File.open(tei_path) )
        tei_obj.add_datastream(tei_ds)
        #contentMetadata
        # content_metadata_ds = tei_obj.datastreams['contentMetadata']
        # params = {
        #   
        # }
        # content_metadata_ds.update_values(params)
        #RELS
        tei_obj.add_relationship(:is_derivation_of, ActiveFedora::Base.load_instance(@pid))
        tei_obj.save
        return tei_obj
      end
    rescue Exception => e
      raise "[ERROR] create_tei_xml: #{e.message}"
      #puts e.backtrace
    end
  end

    def create_morph_adorned_object
      pid = @pid + ".morphadorned"
      begin
        replacing_object(pid) do
          morph_adorned_obj = Bamboo::MorphAdornedText.new(:pid=>pid)
          #TEI ds
          morph_adorned_path = File.join(@adorned_path, @tei_filename)
          morph_adorned_ds = ActiveFedora::Datastream.new(:dsLabel => "Morph-Adorned XML", :controlGroup => "M", :blob =>File.open(morph_adorned_path) )
          morph_adorned_obj.add_datastream(morph_adorned_ds)
          #RELS
          morph_adorned_obj.add_relationship(:is_derivation_of, ActiveFedora::Base.load_instance(@pid))
          morph_adorned_obj.save
          return morph_adorned_obj
        end
      rescue Exception => e
        raise "[ERROR] create_morph_adorned_xml: #{e.message}"
        #puts e.backtrace
      end
    end
   

  def create_page_image_objects
    begin
      pages = Array.new
      image_urls.each do |i|
        puts "[INFO] Creating page #{i[:page]}"
        pid = "#{@pid}.#{i[:page]}"
        replacing_object(pid) do
          page_obj = Bamboo::PageImage.new(:pid=>pid)
          img_ds = ActiveFedora::Datastream.new(:dsLabel=>"Page image #{i[:page]}", :controlGroup=>'R', :dsLocation=>i[:url])
          page_obj.add_datastream(img_ds)   
          page_obj.save  
          #PROPS
          props = page_obj.datastreams['properties']
          props.seq_values << "#{i[:page]}"
          props.page_values << "#{i[:n]}"
          props.div_values << ""
          props.save
          #RELS
          page_obj.add_relationship(:is_part_of, ActiveFedora::Base.load_instance(@pid))
          page_obj.save
          pages << page_obj
        end
      end
      pages
    rescue Exception => e
      puts e.backtrace
      raise "[ERROR] create_page_image_objects: #{e.message}"
    end
  end

  def gale_url(facs, n)
    intro = "http://callisto.ggsrv.com/imgsrv/Fetch?recordID="

    # there is a case (see K00122.00) where the facs is incorrect
    # instead of the page image sequence number, it is the entire image_set_id + page_num
    # here we account for this case
    if facs.start_with? image_set_id
      num_str = facs
    else
      # otherwise page number needs to be set to four digits, padded with zeros
      page_num = "%04d" % facs
      num_str = image_set_id + page_num + "0"
    end

    coda = "&contentSet=#{content_set}"
    
    url = intro + num_str + coda
    page = num_str[-5..-2].to_i
    
    {:page=>page, :n=>n, :url=>url}

  end

  def michigan_url(facs, n)
    intro = "http://quod.lib.umich.edu/e/ecco/"

    if facs.start_with? image_set_id
      page = facs[-5..-2]
    else
      page = facs
    end

    #remove the leading zeros
    page = page.to_i.to_s
    
    url = intro + dlps_id + ".0001.001/" + page

    {:page=>page.to_i, :n=>n, :url=>url}

  end

  def tei_header_xml
    orig = @tei_xml.css("TEI > teiHeader")
  end

  def title
    tei_header_xml.css("teiHeader > fileDesc > titleStmt > title").text
  end

  def tcpid
    tei_header_xml.css("teiHeader > fileDesc > publicationStmt > idno[type='TCP']").text
  end

  def image_set_id
    tei_header_xml.css("teiHeader > fileDesc > publicationStmt > idno[type='ImageSetID']").text
  end

  def dlps_id
    tei_header_xml.css("teiHeader > fileDesc > publicationStmt > idno[type='DLPS']").text
  end

  def content_set
    tei_header_xml.css("teiHeader > fileDesc > publicationStmt > idno[type='ContentSet']").text
  end

  def tcpid_to_pid
    "bamboo:#{tcpid}"
  end

  def replacing_object(pid)
    begin
      object = ActiveFedora::Base.load_instance(pid)
      puts "[INFO] Replacing object: #{pid}"
      puts object
      object.delete unless object.nil?
    rescue ActiveFedora::ObjectNotFoundError
      puts "[INFO] Creating new object: #{pid}"
    end
    yield
  end

end
