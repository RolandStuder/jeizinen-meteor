
Handlebars.registerHelper('repeat', function(n, block) {
    var accum = '';
    for(var i = 0; i < n; ++i)
        accum += block.fn(i);
    return accum;
});

Handlebars.registerHelper('session',function(input){
    return Session.get(input);
});

Handlebars.registerHelper('setTrue',function(attr, id){
	return 'data-onClick-setTrue="' + attr + '" data-id="' + id + '"'
});
