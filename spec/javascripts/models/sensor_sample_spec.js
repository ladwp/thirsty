describe("SensorSamples", function() {
  var sensor_site = new SensorSite({id: 5})

  describe("#initialize", function() {
    it("should set the sensor_site id", function() {
      var sensor_samples = new SensorSamples([], {sensor_site: sensor_site});
      expect(sensor_samples.sensor_site).toBe(sensor_site);
    });
    it("should default to last months samples", function() {
      spyOn(Date, 'now').andReturn(new Date(2012, 0, 25));
      var sensor_samples = new SensorSamples([], {sensor_site: sensor_site});
      expect(sensor_samples.sampled_after).toEqual(new Date(2011, 9, 25));
    });
  });

  describe("#url", function() {
    var sensor_samples = new SensorSamples([], {sensor_site: sensor_site});

    describe("when no dates are specified", function() {
      it("should include no date params", function() {
        sensor_samples.sampled_after = null;
        sensor_samples.sampled_before = null;

        expect(sensor_samples.url()).toEqual("/sites/5/samples.json");
      });
    });

    describe("when just 'sampled_after' is set", function() {
      it("should just add sampled_after param", function() {
        sensor_samples.sampled_after = new Date(12345);
        sensor_samples.sampled_before = null;
        expect(sensor_samples.url()).toEqual('/sites/5/samples.json?sampled_after=%221970-01-01T00%3A00%3A12.345Z%22')
      });
    });

    describe("when just 'sampled_before' is set", function() {
      it("should just add sampled_before param", function() {
        sensor_samples.sampled_after = null;
        sensor_samples.sampled_before = new Date(56789);
        expect(sensor_samples.url()).toEqual('/sites/5/samples.json?sampled_before=%221970-01-01T00%3A00%3A56.789Z%22')
      });
    });

    describe("when both sampled_after and sampled_before is set", function() {
      it("should add both sampled_after and sampled_before params", function() {
        sensor_samples.sampled_after = new Date(12345);
        sensor_samples.sampled_before = new Date(56789);
        expect(sensor_samples.url()).toEqual('/sites/5/samples.json?sampled_after=%221970-01-01T00%3A00%3A12.345Z%22&sampled_before=%221970-01-01T00%3A00%3A56.789Z%22')
      });
    });
  });

});
