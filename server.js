Meteor.methods({
	reset: function() {
		PlaceholderImages.remove({});
		return true;
	},
	mock: function() {
		fakeCollection = new Meteor.Collection('fakeCollection')
	}
});