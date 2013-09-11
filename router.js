// wildcard router takes path in the form of layoutname/context1.context2.templateName

function getURLParameters() {
  var searchString = window.location.search.substring(1)
    , params = searchString.split("&")
    , hash = {}
    ;

  if (searchString == "") return {};
  for (var i = 0; i < params.length; i++) {
    var val = params[i].split("=");
    hash[unescape(val[0])] = unescape(val[1]);
  }
  return hash;
}


var parse = function(path) {
  path = path.split('/')
  path.shift();

  // now check which case applies layout or template....
  
  if (path.length > 2) { // too long, can't handle it...
    page = 'notFound';
    console.log('!path too long cannot handle it');
  
  } else if (path == '') {
    sections = 'index';

  } else if (path.length === 2 ) { 
    layout = path[0];
    sections = path[1]

  } else if (path.length === 1 ) { // /template
    sections = path[0]
  } 

  sections = sections.split('.');
  page = sections[sections.length-1];
  
  if (!Template[page]) page = 'notFound';
  if (!Template[layout]) layout = 'renderPage';

  return {page: page, layout: layout, sections: sections};
}

Meteor.Router.add({
  '*': function() {
    var path = parse(this.pathname);
    params = getURLParameters();

    $.each(params,function(name,value){
      Session.set(name,value);
    });

    
    FlashMessages.clear();
    FlashMessages.load();

    Session.set('currentPage',path['page'])
    Session.set('currentLayout',path['layout'])
    Session.set('currentSections',path['sections'])
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
    // enableClickActions();
  }
});

if (Meteor.isClient) {
  Template.renderPage.events({
    'click [data-onClick-setTrue]' : function () {
      MockData[this.collection].update(this._id, {$set: {isEdit: true}})
    },
    'click input[type=submit]' : function (event) {
      event.preventDefault();
      console.log(event.target)
      console.log($(event.target).parent('form'))
      updateEntry($(event.target).parent('form'))
      MockData[this.collection].update(this._id, {$set: {isEdit: false}})
      updateEntry(this);
    }
  });
}


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

