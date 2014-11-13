Package.describe({
    summary: "Jeizinen - a UI prototyping framework",
    version: "0.5.5",
    name: "rstuder:jeizinen",
    git: "https://github.com/RolandStuder/jeizinen-meteor.git"
});

Package.on_use(function (api, where) {

    Npm.depends({
        yamljs: "0.1.5",
        csvtojson: "0.3.8"
    });
	
    both   = ['client', 'server'];
    client   = ['client'];
    server   = ['server'];

    api.use('templating@1.0.9', client);
    api.use('jquery@1.0.1', both);
    api.use('iron:router@1.0.1', 'client');
    api.use('underscore@1.0.1', both);
    api.use('spacebars@1.0.3', both);
    api.use('backbone@1.0.0', both);
    api.use('mongo@1.0.8', both);
    api.use('mizzao:bootstrap-3@3.3.0', 'client');
    api.use('coffeescript@1.0.4', both);


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




