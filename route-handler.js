
Meteor.Router.add({
  '': 'index',
  '*': function() {
  	return this.pathname.slice(1,this.pathname.length);
  }
});

// if (Meteor.isClient) { console.log("yes")};


// if (Meteor.Router) {
// 	console.log("yes");
// } else { console.log("no");}