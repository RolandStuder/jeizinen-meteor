// // stuff to make sure, we don't add another pool of images just because the subscription are not completed yet...

var checkIfCollectionIsReady = function() {
  console.log('checking...')
  if(PlaceholderImages.findOne()) {
    Meteor.clearInterval(waitForCollection);
    replacePlaceholders();
  }
}

var initializeCollectionWithDocument = function () {
  if(PlaceholderImages.find({}).count()==0){
    console.log('placeholderImages initialized....');
    PlaceholderImages.insert({comment:"intialize, necessery because I cannot check if a collection is truly empty while using autosubscribe"});
  }
}




var createImagePoolDocument = function(query,photoArray) {
  if(photoArray.length>0) {
    PlaceholderImages.insert({query: query, photos: photoArray});
    console.log("Images for '" + query + "'' added to image pool");
    replaceNow();
  } else {
    console.log("not getting any pictures, change your search and try again")
  }
}

var getFlickrImages = function(query) {
  console.log('getting pictures from flickr...');
  $.ajax({
    url: "http://ycpi.api.flickr.com/services/rest/",
    data: { 
      api_key: '1a02addb94c985970bca4339af022b01',
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
        createImagePoolDocument(query, response.photos.photo);
      }
    });
}

var replaceNow = function() { 
  queryCounter = {};
  $(placeholders).each(function(index){
    query = $(this).attr('search');

    var photos = PlaceholderImages.findOne({query:query}).photos
    
    if ( queryCounter[query] == undefined ) {
      queryCounter[query]=0;
    } else if (queryCounter[query] > photos.length-2) {
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

var replacePlaceholders = function() {
  placeholders = $("img[search]");
  uniqueQueries = [];

  placeholders.each(function(){ // get unique queries
    query = $(this).attr('search');
    if ($.inArray(query,uniqueQueries)===-1) { uniqueQueries.push(query)}
  })

  $(uniqueQueries).each(function(index, value) {
    if (PlaceholderImages.find({}).count() > 0) { // i think this check is no longer necessary
        if( !PlaceholderImages.findOne({query:value})) { getFlickrImages(value); }  // somehome !findOne... messed this up
      }
    });
  replaceNow();
}



// alt+click lets you remove an image from an image pool

var enableRemovalOfPlaceholders = function() {

  var remove = function(image) {
    image = $(image);
    var query = image.attr('search');
    var pool = PlaceholderImages.findOne({query:query});
    var photos = pool.photos;
    photos.splice(image.attr('placeholder-position'),1);
    if (photos.length===0) { 
      PlaceholderImages.remove(pool._id)
    } else {
      PlaceholderImages.update(pool._id, {$set: {photos:photos}});
      replaceNow();
    }
  }

// delegated binding...

  $('body').on('click', 'img[search]', function(e){
    if (e.altKey) {
      remove(this);
    }
  })
}


Meteor.startup( function() {
  Meteor.setTimeout(initializeCollectionWithDocument,5000)
  enableRemovalOfPlaceholders();

  // Main function is called when a template is rendered
  replaceImagePlaceholders = function() {
    if ($("img[search]").length) {
      if(!(PlaceholderImages.findOne())) {
        waitForCollection = Meteor.setInterval(checkIfCollectionIsReady,100)
      } else {
        replacePlaceholders();
      }
    }
  }

});
