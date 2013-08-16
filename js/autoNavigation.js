

$(document).ready(function() {
	anchors = $('a[name]');
	console.log(anchors);
	$(anchors).each(function(){
		var link = '<a href="#' + $(this).attr('name') + '">'+ $(this).attr('name') +'</a>';
		$("#autoNavigation ul").append('<li />').find("li:last").append(link);
	})

});



  // titles = $("[data-autoNavigation]").find("h2")
  // var index = 0;
  // list = $("#autoNavigation ul");
  // titles.wrap('<a>').each(function(){
  // 	index++;
  // 	$(this).parents('a').attr('name',index).attr('id',index).addClass('anchor-link');
  // 	var link = '<a href="#' + index + '">'+ $(this).text() +'</a>';
  // 	$("#autoNavigation ul").append('<li />').find("li:last").append(link);
  // })
