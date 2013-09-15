Package.describe({
    summary: "Jeizinen - a UI prototyping framework"
});

Package.on_use(function (api, where) {
	
    both   = ['client', 'server'];
    client   = ['client'];
    server   = ['server'];

	api.use('jquery', both);
    api.use('router', 'client');
    api.use('underscore', both);
	api.use('templating', both);
    api.use('handlebars', both);
    api.use('backbone', both);
    api.use('mongo-livedata', both);
    api.use('bootstrap-3', 'client');
    api.use('coffeescript', both);

    api.add_files(['server-and-client.js'], both);
    api.add_files(['server.js'], 'server');
    api.add_files([ // client files
            'placeholder-images.js',
            'view-helpers.js',
        ], ['client']);

    api.add_files([ // client files
            'controllers/events.coffee',
            'controllers/collections.coffee',
            'controllers/errors.coffee',
            'controllers/router.coffee',
            'lib/random.coffee',
            'templates/templates.html'
        ], client);
    api.add_files(['flash-messages.js','flash-messages.html'], ['client'])

    api.export('PlaceholderImages');
    api.export('FlashMessages');
    api.export('Collection');
    api.export('collection');
    api.export('Mock');
    api.export('populateEditForms');

});

