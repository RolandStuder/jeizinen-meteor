---
layout: default
title: Docs
---

{%raw %}
<div class="lead">
A javascript prototyping framework to quickly create  highly interactive UI prototypes.
</div>
Jeiziner is a meteorite package for [Meteor.js](http://meteor.com). Not published to atmosphere yet.

<div class="alert alert-warning">
This is an early alpha version, documentation may not be up to date!
</div>

<a name="Pages &amp; Layout"> </a> 
## Pages and layout

In one html-file you define the layout, for example you create a `_layout.html`

	<html>
		<head><title>Apptitle</title></head>
		<body>
			<h1>MyApp</h1>
			{{> renderPage}}
		</body>
	<html>

Now you can enter or link any URL like `localhost:3000/myTemplate`and Jeizinen will try to render a template with that name...

A template looks like this

	<template name="myTemplate">
		... some content ...
	</template>

Now just start creating templates and link to them with regular links. You can nest templates within templates by using `{{> anyTemplateName }}`.

This way you can easily create multiple pages and components like navigation bars...

### multiple layouts

You can use multiple layouts:
	
In your main `html` put {{> renderLayout}} instead of {{> renderPage }}. Then create a template that contains {{> renderPage}} like:
	
	<template name="layoutName">
		... some navigation or stuff ...
		{{> renderPage }}
	</template>

Now you can navigate to page like `/layoutName/pageName` and the template (pageName) will be surrounded by the layout (layoutName).

Note: You cannot render a layout without a template.

### Automatically get .active on links

All links to the current page, get the css class `.active`, also links within Bootstrap navigation elements are automatically set to `.active`.

If you have a navigation with multiple levels, then you can set parent sections as 'active' by writing your links as follows

    <a href="documents.someTemplate">...</a>

When going to /documents.someTemplate `someTemplate` will be rendered and links pointing to `someTemplate` and links pointing to `documents` will get the .active class.

<a name="Mockdata"> </a> 
## random data like names and phonenumbers

	{{random 'name'}}

Will return a random combinations of a first name and a family name. Other options are:

	{{random 'firstName'}}
	{{random 'familyName'}}
	{{random 'phoneNumber'}}
	{{random 'email'}}

more to come... (dates, birthdays)

### random pick of a list defined by yourself

	{{pick 'The Alliance, The Rebels, Neutral'}}

Will return one of the comma-separated options.

## lists of objects with random data

You can create sets of datas, called collections, and can use them in your views without defining them beforehand. For example you can create a list of people like this:

	{{#collection 'people' create='10'}}
		{{field 'name'}}
	{{/collection}}

This will output a list of 10 names. **This data is saved and will not change, if you switch between pages.** However if you reload a page, the collections are reset.

If you use on the options that work for the random helper, it automatically returns a random value. More possibilities are available:

	{{#collection 'people' create='10'}}
		{{field 'name' random="firstName"}} // will give you a random first name
		{{field 'category' pick="a,b,c"}} // will return a random pick
	{{/collection}}

<a name="Image Placeholders"> </a> 		
## add placeholder images from flickr

	<img data-search="dolphins">

Image tags with the attribute `data-search` will automatically point to a flickr image that fits the search string.

If you a picture does not fit your need, alt-click on it, it will be replaced by the next one.

<a name="Flash Messages"> </a> 		
## Flash Messages

If you include the `{{> flashMessages }}`-template somehwere you can display messages.
Messages use the [bootstrap-3 alert-classes](http://getbootstrap.com/components/#alerts): just pass 'success', 'info' or 'danger' to style the message.

#### via data attributes

	<a href="..." data-flash-message="This is good!" data-flash-message-type="success">

When you click on this link, it will show:

<div class="alert alert-success">This is good!</div>

<a name="Get Started"> </a>
## To get started...

- Install [Meteor.js](http://meteor.com)
- Install [Meteorite](https://github.com/oortcloud/meteorite).
- run the command `meteor create myapp`
- In your Meteor App create `smart.json` in the root directory to something like

		{
		  "meteor": {
		    "git": "https://github.com/meteor/meteor.git",
		    "branch": "master"
		  },
		  "packages": {
		  	"jeizinen": {
		  		"git": "https://github.com/RolandStuder/jeizinen-meteor.git"
		  	}
		  }
		}

- recommended: run command `mrt add bootstrap-3`
- run the command `mrt`
- point your browser to `localhost:3000`

<a href="https://github.com/RolandStuder/jeizinen-meteor" class="btn btn-success btn-block">Jeizinen on GitHub <br><small>Download or clone</small></a>
{%endraw %}