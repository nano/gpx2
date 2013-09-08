require "spec_helper"

describe GPX2::Segment do
  let(:doc) { GPX2::Document.parse_file(GPX_FIXTURE_PATH) }
  let(:segment) { doc.tracks.first.segments.first }

  it "should have trackpoints" do
    segment.should have(602).trackpoints
  end
end
