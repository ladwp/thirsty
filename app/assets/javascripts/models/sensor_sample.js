var SensorSample = Backbone.Model.extend({});

var SensorSamples = Backbone.Collection.extend({
  model: SensorSample,

  initialize: function(models, opts) {
    this.sensor_site = opts.sensor_site;


    //Default includes samples from the last three months
    this.sampled_after = moment().subtract(3, "months");
    this.sampled_before = moment()
  },

  parse: function(response) {
    this.sampled_after = moment(response.sampled_after);
    this.sampled_before = moment(response.sampled_before);

    return response.samples;
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
