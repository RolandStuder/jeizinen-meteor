$(document).ready(function() {
	$('pre').add('code').addClass('prettyprint')

	var path = $(location).attr('pathname');
	if (path=="/jeizinen-meteor/" || (path.indexOf('index') >= 0 )) {
		$('#docs').addClass("active");
	} else {
		$('#blog').addClass("active")
	}

	// $('#tableOfContents').affix({
	//       offset: {
	//         top: $('.header').height()
	//       }
	// });
	// $('body').scrollspy({ target: '#tableOfContents' })


	String.prototype.repeat = function(num) {
		return new Array(num + 1).join(this);
	}
	var ToC =
		"<nav role='navigation' class='table-of-contents nav nav-pills nav-stacked'>" +
			"<ul class='nav'>";

	var newLine, el, title, link, level, baseLevel;

	$("h2,h3").each(function() {

		el = $(this);
		title = el.text();
		link = "#" + el.attr("id");

		var prevLevel = level || 0;
		level = this.nodeName.substr(1);
		if(!baseLevel) { // make sure you start with highest level of heading or it won't work
			baseLevel = level;
		}

		if(prevLevel == 0) {
			newLine = '<li>';
		} else if(level == prevLevel) {
			newLine = '</li><li>';
		} else if(level > prevLevel) {
			newLine = '<ul class="nav"><li>'.repeat(level - prevLevel);
		} else if(level < prevLevel) {
			newLine = '</li></ul>'.repeat(prevLevel - level) +
			'</li><li>';
		}
		newLine += "<a href='" + link + "'>" + title + "</a>";

		ToC += newLine;

	});

	ToC += '</li></ul>'.repeat(level - baseLevel) +
				"</li>" +
			"</ul>" +
		"</nav>";

	$("#tableOfContents").append(ToC);

});
