require 'spec_helper'

module AqueductCrawler
  describe SampleParser do
    let(:sample_row_html) { File.read('spec/fixtures/sample_row.html') }
    let(:sample_row) { Nokogiri::HTML::DocumentFragment.parse(sample_row_html).children[0] }
    let(:sample_parse) { SampleParser.new(sample_row) }

    describe "#initialize" do
      subject { sample_parse }
      # e.g.  8/6/12 7:44:24 PM
      its(:sampled_at) { should == Time.parse("Aug 6, 2012 19:44:24 PDT") }
    end

    describe "#to_hash" do
      subject { sample_parse.to_hash }
      its(:to_hash) { should == {
          :sampled_at => Time.parse("Aug 6, 2012 19:44:24 PDT"),
          :value => 12.3
        }
      }
    end
  end
end
