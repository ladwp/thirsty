require 'spec_helper'

module AquaductCrawler
  describe Site do
    let(:site) { AquaductCrawler::Site.new("fake_station_id.html") }
    before do
      stub_request(:get, "http://wsoweb.ladwp.com/Aqueduct/realtime/fake_station_id.html").
        with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => File.read('spec/fixtures/fake_feed.html'), :headers => {})
    end

    describe '#site_name' do
      subject { site.site_name }
      context 'when it is a flow measurement' do
        it { should == "Cottonwood Ck. At LAA" }
      end
    end

    describe "#measurement_type" do
      subject { site.measurement_type }
      context 'when it is a flow measurement' do
        it { should == "Flow" }
      end
    end

    describe "#measurements" do
      subject { site.measurements }
      its(:size) { should == 5 }
      it { should == [
        Sample.new(:sampled_at => DateTime.parse("8/6/12 7:44:24 PM"), :value => 0.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("8/6/12 6:44:24 PM"), :value => 1.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("8/6/12 5:44:24 PM"), :value => 2.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("8/6/12 4:44:24 PM"), :value => 3.0, :site_id => "fake_station_id"),
        Sample.new(:sampled_at => DateTime.parse("8/6/12 3:44:24 PM"), :value => 4.0, :site_id => "fake_station_id")
      ]}
    end

  end
end
