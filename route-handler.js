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
    addActiveClassToLinks()
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
