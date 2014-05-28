Package.describe({
    summary: "Jeizinen - a UI prototyping framework"
});

Package.on_use(function (api, where) {

    Npm.depends({
        yamljs: "0.1.5",
        csvtojson: "0.3.4"
    });
	
    both   = ['client', 'server'];
    client   = ['client'];
    server   = ['server'];

    api.use('templating', client);
	api.use('csv-to-collection', both);
    api.use('jquery', both);
    api.use('iron-router', 'client');
    api.use('underscore', both);
    api.use('handlebars', both);
    api.use('backbone', both);
    api.use('mongo-livedata', both);
    api.use('bootstrap-3', 'client');
    api.use('coffeescript', both);


    api.add_files(['server-and-client.js'], both);
    api.add_files([
            'server.js'
        ],both);

    api.add_files([ // client files
            'placeholder-images.coffee',
            'view-helpers.coffee',
        ], ['client']);

    api.add_files([ // client files
            'controllers/events.coffee',
            'controllers/errors.coffee',
            'controllers/router.coffee',
            'controllers/collections.coffee',
            'lib/random.coffee',
            'templates/templates.html',
            'templates/bootstrap.html'
        ], client);
    api.add_files(['controllers/dataImport.coffee'],both)

    api.add_files(['flash-messages.js','flash-messages.html'], ['client'])


    api.export('PlaceholderImages');
    api.export('FlashMessages');
    api.export('Collection');
    api.export('collection');
    api.export('seed');
    api.export('populateEditForms');
    api.export('Template');

});




