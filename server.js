Meteor.methods({
	reset: function() {
		PlaceholderImages.remove({});
		return true;
	},
	mock: function() {
		fakeCollection = new Meteor.Collection('fakeCollection')
	}
});

Meteor.startup(
	function() {
		console.log("Jeizinen UI Prototyper started started!");
});
