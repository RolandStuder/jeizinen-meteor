Meteor.methods({
	reset: function() {
		PlaceholderImages.remove({});
		return true;
	}
});