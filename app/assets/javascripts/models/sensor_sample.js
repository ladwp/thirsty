var SensorSample = Backbone.Model.extend({});

var SensorSamples = Backbone.Collection.extend({
  model: SensorSample,

  initialize: function(models, opts) {
    this.sensor_site = opts.sensor_site;

    var now = new Date(Date.now());

    //Default includes samples from the last month
    this.sampled_after = new Date(now.setMonth(now.getMonth() - 3));
    this.sampled_before = null;
  },

  /**
   * build the path to the site_samples based on optional before/after constraints
   */
  url: function() {
    var site_samples_path = this.sensor_site.url() + "/samples.json";

    date_filters = {}
    if (this.sampled_after != null) {
      date_filters.sampled_after = JSON.stringify(this.sampled_after);
    }
    if (this.sampled_before != null) {
      date_filters.sampled_before = JSON.stringify(this.sampled_before);
    }
    
    if ($.isEmptyObject(date_filters)) {
      return site_samples_path
    } else {
      return site_samples_path += '?' + $.param(date_filters);
    }
  }
});
