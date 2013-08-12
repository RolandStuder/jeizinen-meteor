Meteor.Router.add({
  '*': function() {
  	path = this.pathname.slice(1,this.pathname.length); // cut of leading '/'
    sections = path.split(".")
    page = sections[sections.length-1]
    page = page || 'index';
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
    addActiveClassToLinks()
  }
});

addActiveClassToLinks = function() {
  $(".nav > li").removeClass("active");
  $("a").removeClass("active").each(function() {
    hrefParts = $(this).attr("href").split(".");
    if (hasMatchingElements(hrefParts,Session.get('currentSections'))) {
      $(this).addClass("active");
      $(this).parents(".nav > li").addClass("active");
    }
  });
}

hasMatchingElements = function(array1, array2) { // return true, if they arrays share one element
  for (var i=0;i<array1.length;i++) {
    if ($.inArray(array1[i],array2)>=0 ){
      console.log("hit");
      return true
    };
  };
  return false
}