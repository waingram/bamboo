Given /^I have a TEI XML file$/ do 
  @tei = "/path/to/tei"
  @tcp_id = "xxxx"
  @ma_path = "/path/to/ma"
  @image_url = "http://url/for/image"
end

When /^I ingest the TEI$/ do
  ingester = Bamboo::Ingester.new
  ingester.ingest(@tei)
end

Then /^the ingester should start building the Fedora object$/
end

Then /^the ingester should know the TCP ID$/ do
  ingester.tcp_id.should == @tcp_id
end

Then /^the ingester should know the MA file location$/ do
  ingester.path_to_ma.should == @ma_path
end

Then /^the ingester should know the Gayle image URL$/ do
  ingester.url_for_image.should == @image_url
end
