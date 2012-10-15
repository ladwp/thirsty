var SensorSites = Backbone.Collection.extend({});
var SensorSite = Backbone.Model.extend({
  urlRoot: "/sites",

  initialize: function() {
    this.sensor_samples = new SensorSamples([], { sensor_site: this });
  }

});
