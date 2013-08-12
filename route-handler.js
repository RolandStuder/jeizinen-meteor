
Meteor.Router.add({
  '': 'index',
  '*': function() {
  	page = this.pathname.slice(1,this.pathname.length); // cut of leading '/'
  	return Template[page] ? page : 'not_found'
  }
});
