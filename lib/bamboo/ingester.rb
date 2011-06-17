

class Bamboo::Ingester
  attr_accessor :unadorned_path
  attr_accessor :adorned_path

  def initialize(unadorned_path, adorned_path)
    @unadorned_path = unadorned_path
    @adorned_path = adorned_path
  end
  
  def load_tei(tei_filename)
    @tei_xml        = Nokogiri::XML::Document.parse(File.read(File.join(@unadorned_path, tei_filename)))
    @pid            = tcpid_to_pid
  end
  
  def image_urls
    pbs   = @tei_xml.css("pb")
    urls = Array.new
    
    pbs.each do |pb|
      n = pb['n']
      facs = pb['facs']
      image_url = gale_url(facs, image_set_id)

      urls << image_url
    end
    urls
  end
    

  def ingest(tei_file)
    puts "Ingesting #{tei_file}..."
    create_book(tei_file)
    #Pages
    #pages = create_page_images(book, tei)
    
    #book.pid
    
  end

  def create_book
    begin
      replacing_object(@pid) do
        book = Bamboo::Book.new(:pid => @pid)
        #TEI header ds
        tei_header_ds                      = book.datastreams['descMetadata']
        tei_header_ds.ng_xml               = Nokogiri::XML::Document.new
        tei_header_ds.ng_xml               << tei_header_xml
        tei_header_ds.attributes[:dsLabel] = "TEI Header"
        book.label = title
        
        book.save
        return book
      end
    rescue Exception => e
      puts "[ERROR] #{e.message}"
    end

  end

  def create_page_images(book_obj)
    #doc        = Nokogiri::XML(File.open(tei_xml))
    tei_xml        = package_file_xml(tei_file)
    
    page_nodes.each do |pn|
      n        = pn['n']
      facs     = pn['facs']
      page_pid = "#{book_obj.pid}.#{facs}"

      page = create_page_image(book_obj, page_pid, image_set_id, n, facs)
      book_obj.add_relationship(:has_part, page)
    end
    book_obj.save
  end

  def create_page_image(book, pid, image_set_id, n="", facs="")
    puts ("Creating page #{facs}")
    replacing_object(pid) do
      tcp_image_asset = Bamboo::TcpPageAsset.new(:pid => pid)
      #properties ds
      props_ds = tcp_image_asset.datastreams['properties']
      props_ds.n_values << n
      props_ds.facs_values << facs
      #content
      image_url = gale_url(facs, image_set_id)
      image_ds  = ActiveFedora::Datastream.new(:dsLabel => "Page image #{facs}", :controlGroup => "E", :dsLocation => image_url)
      tcp_image_asset.add_datastream(image_ds)

      #RELS_EXT
      tcp_image_asset.add_relationship(:is_part_of, book)
      
      tcp_image_asset.save
      tcp_image_asset

    end
  end

  def gale_url(facs, image_set_id)
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

    intro + num_str + coda

  end

  def tei_header_xml
    @tei_xml.css("TEI > teiHeader")
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

  def content_set
    tei_header_xml.css("teiHeader > fileDesc > publicationStmt > idno[type='ContentSet']").text
  end

  def tcpid_to_pid
    "bamboo:#{tcpid}"
  end

  def replacing_object(pid)
    begin
      object = ActiveFedora::Base.load_instance(pid)
      puts "Replacing object: #{pid}"
      object.delete unless object.nil?
    rescue ActiveFedora::ObjectNotFoundError
      puts "Creating new object: #{pid}"
    end
    yield
  end

end
