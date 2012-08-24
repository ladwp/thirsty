require 'spec_helper'

module AquaductCrawler
  describe SiteParse do
    let(:site_parse) { AquaductCrawler::SiteParse.new("fake_station_id.html") }
    before do
      stub_request(:get, "http://wsoweb.ladwp.com/Aqueduct/realtime/fake_station_id.html").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/fixtures/fake_feed.html'), :headers => {})
    end

    describe '#site_name' do
      subject { site_parse.site_name }
      context 'when it is a flow measurement' do
        it { should == "Cottonwood Ck. At LAA" }
      end
    end

    describe "#measurement_type" do
      subject { site_parse.measurement_type }
      context 'when it is a flow measurement' do
        it { should == "Flow" }
      end
    end

    describe "#sample_parses" do
      subject { site_parse.sample_parses }
      its(:size) { should == 5 }
      it {
        (subject.map &:sampled_at).should == [
          Time.parse("Aug 6, 2012 7:44:24 PM PDT"),
          Time.parse("Aug 6, 2012 6:44:24 PM PDT"),
          Time.parse("Aug 6, 2012 5:44:24 PM PDT"),
          Time.parse("Aug 6, 2012 4:44:24 PM PDT"),
          Time.parse("Aug 6, 2012 3:44:24 PM PDT"),
        ]}
    end

  end
end

__END__
 :value => 0.0, :site_id => "fake_station_id"),
 :value => 1.0, :site_id => "fake_station_id"),
 :value => 2.0, :site_id => "fake_station_id"),
 :value => 3.0, :site_id => "fake_station_id"),
 :value => 4.0, :site_id => "fake_station_id")
