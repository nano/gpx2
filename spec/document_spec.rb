require "spec_helper"

describe GPX2::Document do
  context "being parsed" do
    let (:doc) { GPX2::Document.parse_file(GPX_FIXTURE_PATH) }

    it "should have a version" do
      doc.version.should == "1.1"
    end

    it "should have a creator" do
      doc.creator.should == "Tracklog"
    end
  end

  it "should parse a XML string" do
    expect {
      GPX2::Document.parse(File.read(GPX_FIXTURE_PATH))
    }.not_to raise_error
  end

  it "should parse from an IO object" do
    expect {
      GPX2::Document.parse(File.open(GPX_FIXTURE_PATH))
    }.not_to raise_error
  end
end
