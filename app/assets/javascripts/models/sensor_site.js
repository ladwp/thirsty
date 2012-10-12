var SensorSite = Backbone.Collection.extend({

  model: SensorSample,

  initialize: function(opts){
    this.site_id = opts.site_id;
    var now = new Date(Date.now());
    //Default to samples from the last month
    this.sampled_after = new Date(now.setMonth(now.getMonth() - 1));
    this.sampled_before = null;
  },

  /**
   * build the path to the site_samples based on optional before/after constraints
   */
  url: function(){

    var base_path = '/sites/';
    var path = base_path + this.site_id + "/" + "samples.json";

    if (this.sampled_after != null) {
      path += "?sampled_after=" + JSON.stringify(this.sampled_after);
      if (this.sampled_before != null) {
        path += "&sampled_before=" + JSON.stringify(this.sampled_before);
      }
    } else {
      if (this.sampled_before != null) {
        path += "?sampled_before=" + JSON.stringify(this.sampled_before);
      }
    }

    return path;
  }
});
