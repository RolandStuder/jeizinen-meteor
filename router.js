// wildcard router takes path in the form of layoutname/context1.context2.templateName

var parse = function(path) {
  path = path.split('/')
  path.shift();

  // now check which case applies layout or template....
  
  if (path.length > 2) { // too long, can't handle it...
    template = 'notFound';
    console.log('!path too long cannot handle it');

  } else if (path.length === 2 ) { 
    layout = path[0];
    template = path[1];

  } else if (path.length === 1 ) { // /template
    template = path[0];

  } else {
    template = 'index';
  }

  if (!Template[template]) template = 'notFound';
  if (!Template[layout]) layout = 'renderPage';

  return {template: template, layout: layout};
}

Meteor.Router.add({
  '*': function() {
    var path = parse(this.pathname);

    Session.set('currentPage',path['template'])
    Session.set('currentLayout',path['layout'])
  }
  
});

// Jeizinen provides two empty templates that can render any layout/template

Meteor.startup(function() {
  Template.renderLayout.content = function() {
      return new Handlebars.SafeString(Template[Session.get('currentLayout')]());
  }

  Template.renderPage.content = function() {
    return new Handlebars.SafeString(Template[Session.get('currentPage')]());
  }

  Template.renderPage.rendered = function() {
    addActiveClassToLinks();
    replaceImagePlaceholders();
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