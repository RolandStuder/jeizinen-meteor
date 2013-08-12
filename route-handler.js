
Meteor.Router.add({
  '*': function() {
  	page = this.pathname.slice(1,this.pathname.length); // cut of leading '/'
  	page = page || 'index';
    page = Template[page] ? page : "not_found";
    Session.set('currentPage', page);
  }
});

Handlebars.registerHelper('renderPage', function(name, options) {
    return new Handlebars.SafeString(Template[Session.get('currentPage')]());
});


Deps.autorun(function() {
  console.log(Session.get('currentPage'));
  $("a").addClass("active");
  $(".nav > li").addClass("active");
})