require "spec_helper"

describe GPX2::Waypoint do
  let(:doc) { GPX2::Document.parse(GPX_FIXTURE_PATH) }
  let(:waypoint) { doc.tracks.first.segments.first.trackpoints[3] }

  it "should have a latitude" do
    waypoint.latitude.should == 49.397594
  end

  it "should have a longitude" do
    waypoint.longitude.should == 11.126152
  end

  it "should have an elevation" do
    waypoint.elevation.should == 326.5
  end

  it "should have a time" do
    waypoint.time.should == Time.utc(2013, 4, 21, 12, 43, 29)
  end
end
