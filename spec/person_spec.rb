require "spec_helper"

describe GPX2::Person do
  let(:doc) { GPX2::Document.parse_file(GPX_FIXTURE_PATH) }
  let(:person) { doc.metadata.author }

  it "should have a name" do
    person.name.should == "Thomas Cyron"
  end

  it "should have an email" do
    person.email.should == "thomas@thc.io"
  end

  it "should have a link" do
    person.link.should be_kind_of GPX2::Link
  end

  it "should have a link with a text" do
    person.link.text.should == "Website"
  end
end
