Given /^I have a TCP package to ingest$/ do 
end

When /^I ingest the TEI file "(.*)"$/ do |tei_file|
  ingester = Bamboo::Ingester.new(File.join PROJECT_ROOT, "spec", "fixtures", "ecco-unadorned")
  @pid = ingester.ingest(tei_file)
end

Then /^I should get back a Fedora object PID "(.*)"$/ do |pid|
  @pid.should == pid
end
