// anchors get added to the navigation, beware that markdown parsing is strange there needs to content in the anchor or it won't work...

$(document).ready(function() {
	anchors = $('a[name]');
	$(anchors).each(function(){
		var link = '<a href="#' + $(this).attr('name') + '">'+ $(this).attr('name') +'</a>';
		$("#autoNavigation ul").append('<li />').find("li:last").append(link);
	})

	// $('pre').add('code').addClass('prettyprint')

	var path = $(location).attr('pathname');
	if (path=="/" || (path.indexOf('index') >= 0 )) {
		$('#docs').addClass("active");
	} else {
		$('#blog').addClass("active")
	}

});