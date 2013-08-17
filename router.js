
Meteor.Router.add({
  '*': function() {
  	path = this.pathname.slice(1,this.pathname.length); // cut of leading '/'
    slicedPath = path.split("/");
    if (slicedPath.length === 2) {
      layout = slicedPath[0];
      Session.set('currentLayout', layout)

      path = slicedPath[1];
    } else {
      path = slicedPath[0];
      Session.set('currentLayout', '');
    }

    sections = path.split(".");
    page = sections[sections.length-1]
    page = Template[page] ? page : "notFound";
    Session.set('currentPage', page);
    Session.set('currentSections', sections)
  }
  
});


Meteor.startup(function() {
  Template.renderLayout.content = function() {
    if (Session.get('currentLayout')!=='') {
      return new Handlebars.SafeString(Template[Session.get('currentLayout')]());
    } else {
      return new Handlebars.SafeString(Template['renderPage']());
    }
  }

  Template.renderPage.content = function() {
    return new Handlebars.SafeString(Template[Session.get('currentPage')]());
  }


  Template.renderPage.rendered = function() {
    addActiveClassToLinks();
    replaceImagePlaceholders();
    addPrettify();
  }
 
  enableRemovalOfPlaceholders();

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


addPrettify = function() { // prettify script is loaded in _layout.html
  $("pre").addClass("prettyprint");
  $("code").addClass("prettyprint");
};


