require File.join(File.dirname(__FILE__), "/../spec_helper")
require 'bamboo'
require 'uri'
require 'net/http'

module Bamboo

  describe Ingester do
    context "making Fedora objects" do

      before(:each) do
        ActiveFedora.init unless Thread.current[:repo]
        
        @unadorned_path = File.join PROJECT_ROOT,"spec","fixtures","ecco-unadorned"
        @adorned_path    = File.join PROJECT_ROOT, "spec", "fixtures", "ecco-adorned-p5simple"
        #unadorned_path = "/home/medusa/Downloads/TCPSource/1420ECCOtexts/1420ECCOtexts"
        
        puts "Instantiating new ingester"
        @ingester = Bamboo::Ingester.new(@unadorned_path, @adorned_path)
      end

      after(:each) do
        begin
          @book.delete
        rescue
        end
        begin
          @page_xml.delete
        rescue
        end
          begin
            @page_xml.delete
          rescue
          end
      end

      it "should gather valid gale image URLs" do
        Dir.glob(File.join(@unadorned_path, "*.xml")) do |f|
          tei_filename = File.basename(f)
          puts "Processing TCP file: #{f}"
          @ingester.load_tei(tei_filename)
          
          # test image URLs randomly 
          img = @ingester.image_urls[rand(@ingester.image_urls.size)]
          url = URI.parse(img)
          puts "Testing URL: #{url}"
          
          # test this is a valid URL, and the content is TIFF
          Net::HTTP.start(url.host, url.port) do |http|
            response = http.get(url.request_uri)
            response.should.kind_of? Net::HTTPOK
            response.content_type.should == "image/tiff"
          end
        end
      end
      
      it "should create a bamboo book" do
        tei_filename = "K000122.000.xml"
        @ingester.load_tei(tei_filename)
        @book = @ingester.create_book
        @book.should_not == nil
        tei_header = @book.datastreams['teiHeader']
        tei_header.attributes[:dsLabel].should == "TEI Header"
      end
      
      it "should create a tei xml object" do
        tei_filename = "K000122.000.xml"
        @ingester.load_tei(tei_filename)
        @tei_xml = @ingester.create_tei_xml
        @tei_xml.should_not == nil
        tei = @tei_xml.datastreams['DS1']
        tei.attributes[:dsLabel].should == "TEI XML"
        puts tei.attributes
      end

        it "should create a morph adorned xml object" do
          tei_filename = "K000122.000.xml"
          @ingester.load_tei(tei_filename)
          @morph_adorned_xml = @ingester.create_morph_adorned_xml
          @morph_adorned_xml.should_not == nil
          morph_adorned = @morph_adorned_xml.datastreams['DS1']
          morph_adorned.attributes[:dsLabel].should == "Morph-Adorned XML"
        end

    end
  end
end

