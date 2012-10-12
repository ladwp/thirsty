describe("SensorSite", function() {
  describe("#initialize", function() {
    it("should set the site id", function() {
      var sensor_plot = new SensorSite({site_id: 5});
      expect(sensor_plot.site_id).toBe(5);
    });
    it("should default to last months samples", function() {
      spyOn(Date, 'now').andReturn(new Date(2012, 0, 25));
      var sensor_plot = new SensorSite({site_id: 5});
      expect(sensor_plot.sampled_after).toEqual(new Date(2011, 11, 25));
    });
  });

  describe("#url", function() {
    var sensor_plot = new SensorSite({site_id: 5});

    describe("when no dates are specified", function() {
      it("should include no date params", function() {
        sensor_plot.sampled_after = null;
        sensor_plot.sampled_before = null;

        expect(sensor_plot.url()).toEqual("/sites/5/samples.json");
      });
    });

    describe("when just 'sampled_after' is set", function() {
      it("should just add sampled_after param", function() {
        sensor_plot.sampled_after = new Date(12345);
        sensor_plot.sampled_before = null;
        expect(sensor_plot.url()).toEqual('/sites/5/samples.json?sampled_after="1970-01-01T00:00:12.345Z"')
      });
    });

    describe("when just 'sampled_before' is set", function() {
      it("should just add sampled_before param", function() {
        sensor_plot.sampled_after = null;
        sensor_plot.sampled_before = new Date(56789);
        expect(sensor_plot.url()).toEqual('/sites/5/samples.json?sampled_before="1970-01-01T00:00:56.789Z"')
      });
    });

    describe("when both sampled_after and sampled_before is set", function() {
      it("should add both sampled_after and sampled_before params", function() {
        sensor_plot.sampled_after = new Date(12345);
        sensor_plot.sampled_before = new Date(56789);
        expect(sensor_plot.url()).toEqual('/sites/5/samples.json?sampled_after="1970-01-01T00:00:12.345Z"&sampled_before="1970-01-01T00:00:56.789Z"')
      });
    });
  });

});
