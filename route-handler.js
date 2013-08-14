
Meteor.Router.add({
  '*': function() {
  	path = this.pathname.slice(1,this.pathname.length); // cut of leading '/'
    sections = path.split(".")
    page = sections[sections.length-1]
    page = Template[page] ? page : "notFound";
    Session.set('currentPage', page);
    Session.set('currentSections', sections)
  }
});


Meteor.startup(function() {

  Template.renderPage.content = function() {
    return new Handlebars.SafeString(Template[Session.get('currentPage')]());
  }

  Template.renderPage.rendered = function() {
    addActiveClassToLinks();
    replaceImagePlaceholders();
  }
});

addActiveClassToLinks = function() {
  $(".nav > li").removeClass("active");
  $("a").removeClass("active").each(function() {
    hrefParts = $(this).attr("href").split(".");
    targetPage = hrefParts[hrefParts.length-1];
    Session.get('currentSections')
    if ($.inArray(targetPage,Session.get('currentSections'))>=0 ) {
      $(this).addClass("active");
      $(this).parents(".nav > li").addClass("active");
    }
  });
}

var replaceImagePlaceholders = function() {


  addImagesToPool = function(query){
    var flickrAPIkey = '1a02addb94c985970bca4339af022b01';

    var addToPool = function(query, response) {
      PlaceholderImages.insert({query: query, photos: response});
      console.log(query + " added to image pool");
      replaceNow();
    }
    // PlaceholderImages.insert({query: query });
    $.ajax({
      url: "http://ycpi.api.flickr.com/services/rest/",
      data: { 
        api_key: flickrAPIkey,
        format: 'json',
        method: 'flickr.photos.search',
          license: 4, // CC attribution license
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
    placeholders = $("img[src^='flickr://']");
    queries = [];

    placeholders.each(function(){
      query = $(this).attr('src').replace('flickr://','');
      if ($.inArray(query,queries)===-1) { queries.push(query)}
    })
    
    console.log("unique queries: "  + queries);

    $(queries).each(function(index, value) {
      if( !PlaceholderImages.findOne({query: value}) ) { addImagesToPool(value); }  
    });

    replaceNow = function() { 
      queryCounter = {};
      $(placeholders).each(function(index){
        query = $(this).attr('src').replace('flickr://','');
        if ( queryCounter[query]!== undefined ) {
          queryCounter[query]=queryCounter[query]+1;
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

  if ($("img[src^='flickr://']").length) replacePlaceholders();

}

