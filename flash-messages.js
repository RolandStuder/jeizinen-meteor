FlashMessages = new Meteor.Collection(null); 

$.extend(FlashMessages,{
	send: function(type, message){
		if (type==='html') type = false;
		return FlashMessages.insert({type: type, message: message, display: false});
	},
	display: function(type, message){
		if (type==='html') type = false;
		FlashMessages.clear(); // only ever display one message, if not using 'send'
		return FlashMessages.insert({type: type, message: message, display: true});
	},
	clear: function(){
		return FlashMessages.remove({display: true});
	},
	load: function(){
		return FlashMessages.update({display: false},{$set:{display: true}});
	}
})


Meteor.startup(function() {
	Template.flashMessages.messages = function() {
		return FlashMessages.find({display: true});
	}	

	$('body').on('click','[data-flash-message]',function(e){
		FlashMessages.send($(this).attr('data-flash-message-type'),$(this).attr('data-flash-message'));
	})
});





