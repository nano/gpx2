require "spec_helper"

describe GPX2::Document do
  let (:doc) { GPX2::Document.parse(GPX_FIXTURE_PATH) }

  it "should have a version" do
    doc.version.should == "1.1"
  end

  it "should have a creator" do
    doc.creator.should == "Tracklog"
  end
end
