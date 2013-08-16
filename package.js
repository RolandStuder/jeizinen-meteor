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
    api.use('mongo-livedata', both)

    api.add_files(['client/router.js', 'client/route_templates.html'], ['client']);
    api.add_files(['server/server.js'], 'server');
    api.add_files(['server-and-client.js'], both);
    api.add_files(['client/view-helpers.js'], 'client');
    api.add_files(['client/placeholder-images.js'], 'client');
    api.add_files(['client/mock-data-helpers.js'], 'client');

});

