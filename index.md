---
layout: default
---

{%raw %}
<div class="jumbotron">
A javascript prototyping framework to quickly create UI prototypes.
</div>

Jeiziner is a meteorite package for [Meteor.js](http://meteor.com).

## Pages and layout

In one html-file you define the layout, for example you create a `_layout.html`

	<html>
		<head><title>Apptitle</title></head>
		<body>
			<h1>MyApp</h1>
			{{> renderPage}}
		</body>
	<html>

Now you can enter oder link any URL like `localhost:3000/myTemplate`and Jeizinen will try to render a template with that name...

A template looks like this

	<template name="myTemplate">
		... some content ...
	</template>

Now just start creating templates and link to them with regular links. You can nest templates within templates by using `{{> anyTemplateName }}`.

This way you can easily create multiple pages and componetens like navigation bars...

### Automatically get .active on links

All links to the current page, get the css class `.active`, also links within Bootstrap navigation elements are automatically set to `.active`.

You can also selectively activate links by pointing your links as follows

    <a href="documents.someTemplate">...</a>

When going to /documents.someTemplate `someTemplate` will be rendered and links pointing to `someTemplate` and links pointing to `documents` will get the .active class.

## Use Mockdata - the `random` helper

In any view, use the `{{random "dataType"}}` helper to create mockdata.

	{{ random "name"}} -> gives you combination of a givenName and a familyName
	{{ random "givenName"}} -> returns a givenName
	{{ random "familyName"}} -> returns a familyName
	{{ random "phoneNumber"}} -> returns a phoneNumber

Please tell [me](mailto:roland.studer@gmail.com) what other dataTypes you need.

### ´pickOne´ helper

To use custom Mockdata you can just use the ´pickOne´ helper and pass it a list of comma-separated values.

	{{ pickOne "male,female"}}


## Create lists easily with the `repeat` helper

You can wrap any content with a repeater, to create lists, just pass an integer and let it the block be repeated. No here it starts to get interesting as you can combine mockdata with the repeater (every block will contain different mock-data)

	{{#repeat 10}}
		<div>
			<b>{{ random "Name"}}</b>
			<small>{{ random "phoneNumber"}}</small>
		</div>
	{{/repeat}}




## To get started...

- Install [Meteor.js](http://meteor.com)
- Install [Meteorite](https://github.com/oortcloud/meteorite).
- Git clone or download the [Jeizinen Prototyper](https://github.com/RolandStuder/jeizinen-meteor). 
- In your Meteor App edit `smart.json` to something like

		{
		  "meteor": {
		    "git": "https://github.com/meteor/meteor.git",
		    "branch": "master"
		  },
		  "packages": {
		  	"jeizinen": {
		  		"path": "/path/to/jeizinen-meteor"
		  	}
		  }
		}


It is not yet available over [atmosphere.meteor.com](http://atmosphere.meteor.com), if you want to use Jeizinen Prototyper [drop my a line](mailto:roland.studer@gmail.com) and I will publish it, so it can be more easily installed (via `mrt add jeizinen`). 

<a href="https://github.com/RolandStuder/jeizinen-meteor" class="btn btn-success btn-block">Jeizinen on GitHub <br><small>Download or clone</small></a>
{%endraw %}