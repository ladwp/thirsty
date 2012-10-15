describe("SensorPlot", function() {

  describe("#initialize", function() {
    it("should assign the sensor site", function() {
      jasmine.Ajax.useMock();
      var sensor_site = new SensorSite({id: 5});
      sensor_site.sensor_samples.fetch();
      var ajax = mostRecentAjaxRequest().response(MockXhrResponses.SensorSample.list.success);
      var $sensor_plot_el = $('div.sensor-plot');
      var sensor_plot = new SensorPlot({model:sensor_site, el: $sensor_plot_el});

      expect(sensor_plot.model).toBe(sensor_site);
    });
  });

  describe("#render", function() {
    it("should render a point per sensor sample", function() {
      jasmine.Ajax.useMock();
      var sensor_site = new SensorSite({id: 5});
      sensor_site.sensor_samples.fetch();
      var ajax = mostRecentAjaxRequest().response(MockXhrResponses.SensorSample.list.success);

      // can we do this in an isolated DOM somehow? 
      // I haven't figure out how to get d3 to work in an abstract dom 
      // - it's selects are all grounded in the document dom
      var $sensor_plot_el = $('<div style="display: none">');
      $('body').append($sensor_plot_el);
      
      var sensor_plot = new SensorPlot({ model: sensor_site, el: $sensor_plot_el });

      sensor_plot.render();

      //verify that we rendered 3 points within the plot
      expect($('circle', $sensor_plot_el).length).toBe(3);
    });
  });

 });
