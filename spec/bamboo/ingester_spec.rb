require File.join(File.dirname(__FILE__), "/../spec_helper")
require 'bamboo'
require 'uri'
require 'net/http'

module Bamboo

  describe Ingester do
    context "making Fedora objects" do

      before(:all) do
        ActiveFedora.init unless Thread.current[:repo]
        
        @unadorned_path = File.join PROJECT_ROOT,"spec","fixtures","ecco-unadorned"
        @adorned_path    = File.join PROJECT_ROOT, "spec", "fixtures", "ecco-adorned-p5simple"
        #unadorned_path = "/home/medusa/Downloads/TCPSource/1420ECCOtexts/1420ECCOtexts"
        
        puts "[INFO] Instantiating new ingester"
        @ingester = Bamboo::Ingester.new(@unadorned_path, @adorned_path)
        @tei_filename = "K000122.000.xml"
        @ingester.load_tei(@tei_filename)
      end

      after(:all) do
        # begin
        #   @book.delete
        # rescue
        # end
        # begin
        #   @tei_obj.delete
        # rescue
        # end
        # begin
        #   @morph_adorned_obj.delete
        # rescue
        # end
        # @page_images.each do |i|
        #   begin
        #     i.delete
        #   rescue
        #   end
        # end unless @page_images.nil?
      end

      it "should gather valid gale image URLs" do
          # test image URLs randomly 
          h = @ingester.image_urls[rand(@ingester.image_urls.size)]
          url = URI.parse(h[:url])
          puts "[INFO] Testing URL: #{url}"
          
          # test this is a valid URL, and the content is TIFF
          Net::HTTP.start(url.host, url.port) do |http|
            response = http.get(url.request_uri)
            response.should.kind_of? Net::HTTPOK
            #response.content_type.should == "image/tiff"
          end
      end
      
      it "should create a bamboo book" do
        @book = @ingester.create_book
        @book.should_not == nil
        puts @book.class.respond_to? :pid_namespace
        tei_header = @book.datastreams['descMetadata']
        tei_header.attributes[:dsLabel].should == "TEI Header"
        tei_header.ng_xml.root.children.empty?.should_not == true
      end
      
      it "should create a tei xml object" do
        @tei_obj = @ingester.create_tei_object
        @tei_obj.should_not == nil
        tei = @tei_obj.datastreams['DS1']
        tei.attributes[:dsLabel].should == "TEI XML"
        tei.blob.should_not == nil
      end

      it "should create a morph adorned xml object" do
        @morph_adorned_obj = @ingester.create_morph_adorned_object
        @morph_adorned_obj.should_not == nil
        morph_adorned = @morph_adorned_obj.datastreams['DS1']
        morph_adorned.attributes[:dsLabel].should == "Morph-Adorned XML"
        morph_adorned.blob.should_not == nil
      end

      it "should create page image objects" do
        @page_images = @ingester.create_page_image_objects
        @page_images.should_not == nil            
      end

      it "should raise an error on incorrect input" do
        lambda {@ingester.load_tei("xxx")}.should raise_error
        lambda {@ingester.load_tei("K000122.000.bad")}.should raise_error
      end
      
    end
  end
end

