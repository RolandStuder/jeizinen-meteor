

replaceImagePlaceholders = function() {
  addImagesToPool = function(query){
    var flickrAPIkey = '1a02addb94c985970bca4339af022b01';

    var addToPool = function(query, response) {
      PlaceholderImages.insert({query: query, photos: response});
      console.log("Images for '" + query + "'' added to image pool");
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

    $(queries).each(function(index, value) {
      if (PlaceholderImages.find({}).count() > 0) {
            if( !PlaceholderImages.findOne({query:value})) { addImagesToPool(value); }  // somehome !findOne... messed this up
          }
        });


    replaceNow = function() { 
      queryCounter = {};
      $(placeholders).each(function(index){
        query = $(this).attr('search');
        var photos = PlaceholderImages.findOne({query:query}).photos
        if ( queryCounter[query] == undefined ) {
          queryCounter[query]=0;
        } else if (queryCounter[query] >= photos.length-1) {
          queryCounter[query]=0;
        } else {
          queryCounter[query]++;
        }
        currentPhoto = photos[queryCounter[query]];
        photoURL = "http://farm" + currentPhoto.farm + ".staticflickr.com/" + currentPhoto.server + "/" + currentPhoto.id + "_" + currentPhoto.secret + ".jpg";
        $(this).attr('src', photoURL);
        $(this).attr('placeholder-position', ''+queryCounter[query]);
      }) 
    };

    replaceNow();
  }


  // I have to check if collections are ready, so I don't make an unnessesary flickr-api call on many restarts
  if ($("img[search]").length) {
    checkIfCollectionIsReady = function() {
      if(PlaceholderImages.findOne()) {
        replacePlaceholders();
        Meteor.clearInterval(waitForCollection);
      }
    }
  
    if(!(PlaceholderImages.findOne())) {
      waitForCollection = Meteor.setInterval(checkIfCollectionIsReady,1000)
    } else {
      replacePlaceholders();
    }
  }
}


// alt+click lets you remove an image from an image pool
enableRemovalOfPlaceholders = function() {
  $('body').on('click', 'img[search]', function(e){
    if (e.altKey) {
      self = $(this);
      var query = self.attr('search');
      var pool = PlaceholderImages.findOne({query:query});
      var photos = pool.photos;
      photos.splice(self.attr('placeholder-position'),1);
      if (photos.length===0) { 
        PlaceholderImages.remove(pool._id)
      } else {
        PlaceholderImages.update(pool._id, {$set: {photos:photos}});
        replaceNow();
      }
    }
  })
}


// puts in an empty entry, that checkIfCollectionIsReady can test against...
Meteor.setTimeout(function(){
  if(PlaceholderImages.find({}).count()==0){
    console.log('placeholderImages initialized....');
    PlaceholderImages.insert({comment:"intialize, necessery because I cannot check if a collection is truly empty while using autosubscribe"});
  }
},5000)


