require "spec_helper"

describe GPX2::Link do
  let(:doc) { GPX2::Document.parse(GPX_FIXTURE_PATH) }
  let(:link) { doc.metadata.author.link }

  it "should have a text" do
    link.text.should == "Website"
  end

  it "should have a type" do
    link.type.should == "text/html"
  end

  it "should have a href" do
    link.href.should == "http://thc.io/"
  end
end
