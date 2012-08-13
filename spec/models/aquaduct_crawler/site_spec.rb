require 'spec_helper'

module AquaductCrawler
  describe Site::Parse do
    let(:parse) { AquaductCrawler::Site::Parse.new("fake_station_id.html") }
    before do
      stub_request(:get, "http://wsoweb.ladwp.com/Aqueduct/realtime/fake_station_id.html").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/fixtures/fake_feed.html'), :headers => {})
    end

    describe '#site_name' do
      subject { parse.site_name }
      context 'when it is a flow measurement' do
        it { should == "Cottonwood Ck. At LAA" }
      end
    end

    describe "#measurement_type" do
      subject { parse.measurement_type }
      context 'when it is a flow measurement' do
        it { should == "Flow" }
      end
    end

    describe "#samples" do
      subject { parse.samples }
      its(:size) { should == 5 }
      it { should == [
        Sample.new(:sampled_at => DateTime.parse("Aug 6, 2012 7:44:24 PM"), :value => 0.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("Aug 6, 2012 6:44:24 PM"), :value => 1.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("Aug 6, 2012 5:44:24 PM"), :value => 2.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("Aug 6, 2012 4:44:24 PM"), :value => 3.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("Aug 6, 2012 3:44:24 PM"), :value => 4.0, :site_id => "fake_station_id")
      ]}
    end

  end
end
