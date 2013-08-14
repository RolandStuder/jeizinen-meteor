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
  replacePlaceholders = function() {
      var flickrAPIkey = '1a02addb94c985970bca4339af022b01';

      $.ajax({
        url: "http://ycpi.api.flickr.com/services/rest/",
        data: { 
          api_key: flickrAPIkey,
          format: 'json',
          method: 'flickr.photos.search',
          license: 4, // CC attribution license
          text: 'color',
          safe_search: 3
        },
        dataType: 'jsonp',
        jsonp: 'jsoncallback',
        success: function(response) {
          replaceNow(response.photos.photo);
        }
      });

      replaceNow = function(photoArray) {
        $("img[src^='flickr://']").each(function(index){
          currentPhoto = photoArray[index];
          photoURL = "http://farm" + currentPhoto.farm + ".staticflickr.com/" + currentPhoto.server + "/" + currentPhoto.id + "_" + currentPhoto.secret + ".jpg";
          // http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{secret}_[mstzb].jpg
          $(this).attr('src', photoURL);
          Session.set('photos', photoArray);
        });
      }
  }

  if ($("img[src^='flickr://']").length) replacePlaceholders();


}

