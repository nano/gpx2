require "spec_helper"

describe GPX2::Metadata do
  let(:doc) { GPX2::Document.parse_file(GPX_FIXTURE_PATH) }
  let(:time) { Time.utc(2013, 8, 25, 13, 29, 11) }

  it "should have a name" do
    doc.metadata.name.should == "Tour"
  end

  it "should have a time" do
    doc.metadata.time.should == time
  end

  it "should have a description" do
    doc.metadata.description.should == "My great description"
  end
end
