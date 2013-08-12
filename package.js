Package.describe({
    summary: "Jeizinen - a UI prototyping framework, with dependencies"
});

Package.on_use(function (api, where) {
	api.use('backbone', ['client', 'server']);
	api.use('jquery', 'client');
	api.use('router', 'client');
	api.use('handlebars', ['client', 'server'])
	api.use('bootstrap-3', 'client');

    api.add_files('route-handler.js', 'client');
    api.add_files('not_found.html', 'client');
});

