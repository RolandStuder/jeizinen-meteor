Package.describe({
    summary: "Jeizinen - a UI prototyping framework"
});

Package.on_use(function (api, where) {
	both = ['client', 'server'];
	api.use('jquery', 'client');
    api.use('router', 'client');
    api.use('underscore', both);
	api.use('templating', both);
    api.use('handlebars', both);
    api.use('backbone', both);
    api.use('mongo-livedata', both);
    api.use('bootstrap-3', 'client');

    api.add_files(['server-and-client.js'], both);
    api.add_files(['server.js'], 'server');
    api.add_files([ // client files
            'placeholder-images.js',
            'route_templates.html',
            'mock-data-helpers.js',
            'view-helpers.js',
            'router.js'
        ], ['client']);

    api.export('PlaceholderImages');
});
