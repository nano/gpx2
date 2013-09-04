require "spec_helper"

describe GPX2::Track do
  let(:doc) { GPX2::Document.parse(GPX_FIXTURE_PATH) }
  let(:track) { doc.tracks.first }

  it "should have tracks" do
    doc.should have(1).tracks
  end

  it "should have track segments" do
    track.should have(1).segments
  end

  it "should have a name" do
    track.name.should == "APR-21-13 15:56:18"
  end

  it "should have link" do
    track.should have(1).links
  end

  it "should have one link with a text" do
    track.links.first.text.should == "Homepage"
  end
end
