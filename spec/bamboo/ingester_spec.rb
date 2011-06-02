require File.join(File.dirname(__FILE__), "/../spec_helper")
require 'bamboo'
require 'uri'
require 'net/http'

module Bamboo 
  
  describe Ingester do 
    context "finding files" do

      before(:each) do 
        unadorned_path = File.join PROJECT_ROOT,"spec","fixtures","ecco-unadorned"
        adorned_path = File.join PROJECT_ROOT,"spec","fixtures","ecco-adorned-p5simple"
        tei_filename = "K000122.000.xml"
        
        @ingester = Bamboo::Ingester.new(unadorned_path, adorned_path)
        @ingester.load_tei(tei_filename)
        @pid = "bamboo:K000122.000"
      end
      
      after(:each) do
        begin
        rescue
        end
      end
      
      it "should gather valid gale image URLs" do
        @ingester.image_urls.each do |img|
          success = false
          url = URI.parse(img)

          Net::HTTP.start(url.host, url.port) do |http|
            response = http.head(url.path)
            case response
            when Net::HTTPSuccess, Net::HTTPRedirection
              case response.content_type
              when "image/tiff", "image/jp2", "image/jpeg"
                success = true
              else
                success = false
              end
            else
              success = false
            end
          end
          success.should be_true
        end
      end
      
    end 
  end
end