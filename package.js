Package.describe({
    summary: "Jeizinen - a UI prototyping framework"
});

Package.on_use(function (api, where) {
	api.use('jquery', 'client');
	api.use('router', 'client');
	api.use('templating', ['client', 'server']);

    api.add_files(['route-handler.js', 'route_templates.html'], 'client');
    api.add_files(['view-helpers.js'], 'client');
    api.add_files(['mock-data-helpers.js'], 'client');
});

