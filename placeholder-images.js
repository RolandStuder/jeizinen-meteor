replaceImagePlaceholders = function() {
  addImagesToPool = function(query){
    var flickrAPIkey = '1a02addb94c985970bca4339af022b01';

    var addToPool = function(query, response) {
      PlaceholderImages.insert({query: query, photos: response});
      console.log("Images for" + query + " added to image pool");
      replaceNow();
    }
    $.ajax({
      url: "http://ycpi.api.flickr.com/services/rest/",
      data: { 
        api_key: flickrAPIkey,
        format: 'json',
        method: 'flickr.photos.search',
          license: "4,5,6,7", // All NC Licenses
          text: query,
          safe_search: 3,
          sort: "relevance"
        },
        dataType: 'jsonp',
        jsonp: 'jsoncallback',
        success: function(response) {
          addToPool(query, response.photos.photo);
        }
      });
  }
  
  replacePlaceholders = function() {
    placeholders = $("img[search]");
    queries = [];

    placeholders.each(function(){
      query = $(this).attr('search');
      if ($.inArray(query,queries)===-1) { queries.push(query)}
    })
    
    console.log("unique queries: "  + queries);

    $(queries).each(function(index, value) {
      if( !PlaceholderImages.findOne({query: value}) ) { addImagesToPool(value); }  
    });

    replaceNow = function() { 
      queryCounter = {};
      $(placeholders).each(function(index){
        query = $(this).attr('search');
        if ( queryCounter[query]!== undefined ) {
          queryCounter[query]++;
        } else {
          queryCounter[query]=0;
        }
        currentPhoto = PlaceholderImages.findOne({query:query}).photos[queryCounter[query]];
        photoURL = "http://farm" + currentPhoto.farm + ".staticflickr.com/" + currentPhoto.server + "/" + currentPhoto.id + "_" + currentPhoto.secret + ".jpg";
        $(this).attr('src', photoURL);
      }) 
    };

    replaceNow();

  }

  if ($("img[search]").length) replacePlaceholders();

}