require "spec_helper"

describe GPX2::Copyright do
  let(:doc) { GPX2::Document.parse_file(GPX_FIXTURE_PATH) }
  let(:copyright) { doc.metadata.copyright }

  it "should have a year" do
    copyright.year.should == "2013"
  end

  it "should have a license" do
    copyright.license.should == "Public Domain"
  end

  it "should have an author" do
    copyright.author.should == "Thomas Cyron"
  end
end
