---
layout: default
title: Docs
---

{%raw %}

# Jeizinen UI Prototyper

A javascript prototyping framework to quickly create  highly interactive UI prototypes for webapplications.

Jeizinen is a package for [Meteor.js](http://meteor.com). License: MIT.

<div class="alert alert-warning">
	Current versions are still experimental and not recommended for use in client-projects!
</div>

## Getting started

- Install [Meteor.js](http://meteor.com)
- create the app `meteor create myapp`
- add the packate `meteor add rstuder:jeizinen`
- start meteor `meteor`
- point your browser to `localhost:3000`

<a href="https://github.com/RolandStuder/jeizinen-meteor" class="btn btn-success btn-block">Jeizinen on GitHub <br></a>

## Templates

In one html file you create the layout template that is shared by all pages

	<template name="layout">
	   <h1>Your Prototype</h1>
	   {{> yield}}
	</template>

Now you can enter or link any URL like `localhost:3000/myTemplate` and Jeizinen will try to render a template with that name.

A template looks like this

	<template name="myTemplate">
		... some content ...
		{{> anyOtherTemplate}}
	</template>

Now just start creating templates and link to them with regular links. You can nest templates within templates by using `{{> anyTemplateName }}`.

This way you can easily create multiple pages and components like navigation bars...

<!-- Wait for bug from iron router to resolve: https://github.com/EventedMind/iron-router/issues/606 -->
<!-- ### multiple layouts

You can use multiple layouts:

In your main `html` put {{> renderLayout}} instead of {{> renderPage }}. Then create a template that contains {{> renderPage}} like:

	<template name="layoutName">
		... some navigation or stuff ...
		{{> renderPage }}
	</template>

Now you can navigate to page like `/layoutName/pageName` and the template (pageName) will be surrounded by the layout (layoutName).

Note: You cannot render a layout without a template. -->

## Navigation

All links to the current page, get the css class `.active`, also links within Bootstrap navigation elements are automatically set to `.active`.

If you have a navigation with multiple levels, then you can set parent sections as 'active' by writing your links as follows

    <a href="documents.someTemplate">...</a>

When going to /documents.someTemplate `someTemplate` will be rendered and links pointing to `someTemplate` and links pointing to `documents` will get the .active class. When you want a subpage to be the home of a section, you have to put the href to something like `documents.documents` otherwise the link will always be displayed as active in this section.

<div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#navigationExample">
          Example for Navigation
        </a>
      </h4>
    </div>
    <div id="navigationExample" class="panel-collapse collapse">
      <div class="panel-body">
       <iframe src="https://jeizinen-examples.herokuapp.com/navigation" height="400"></iframe>
      </div>
    </div>
  </div>
  <div class="panel panel-default">
    <div class="panel-heading">
      <h4 class="panel-title">
        <a data-toggle="collapse" data-parent="#accordion" href="#navigationCode">
          Code for Navigation
        </a>
      </h4>
    </div>
    <div id="navigationCode" class="panel-collapse collapse">
      <div class="panel-body">
      		<script src="http://gist-it.sudarmuthu.com/github/RolandStuder/jeizinen-examples/blob/master/examples/navigation.html?footer=no"></script>
      </div>
    </div>
</div>

## Data

It has an underlying Data layer, that allows use of realistic data. There are two basic concepts:

* Collections are basically Datasets you can iterate over
* Session Variables hold key value pairs

### Session Variables

You can set a session variable with an input tag:

	<input type="text" name="userName" value="{{userName}}">
	{{session "userName"}}

The input is automatically saved to a session variable. No need to submit it. Set the value to `{{userName}` if you want to keep the valut in the input field across page changes. See more possibilites in [autosaving](#autosaving)


### Collections & Documents

You can create collections directly in a template with the repeat helper

	{{#repeat collection="contacts" create="100"}}
		{{field "name" random="name"}}
	{{/repeat}}

Crazy I know, but we are prototyping here ;-)

Same works with the document helper

	{{#document collection="contacts" create="100"}}
		{{field "name" random="name"}}
	{{/document}}


### Importing data with CSV or YAML

Any CSV- or YAML-file you put in the directory `public/data` will be read and put into a collection. You need to create a separate file for every collection you want to use in your prototype. If you put a file like `people.csv` in that folder, you will be able to use its data within a collection or document-helper. For example: `#{{collection name="people"}}`. Any data of any column can now be used within that wrapper (do not use spaces or special characters in the columns names though).

#### use in collection-helper

	{{#repeat name="csvImport"}}
		{{columnName}} // no need for field name="columnname" if the data already exists
		{{field "notInCSV" pick="0,1"}} // you can mix existing data, with newly created random data.
	{{/repeat}}

#### use in document-helper

Of course sometimes we just want to see one entry of a list. You do this by using the wrapper '{{#document}}'. Any link that is clicked in a collection-helper automatically sets a hidden session variable, that the clicked element is the current element. So you can link to a detail page and it will automatically show the correct document.

	{{#document collection="csvImport"}}
		{{columnName}} //works just like in the collection
	{{/document}}


### changing data

By putting a `form` in a document or collection wrapper, you can update the model automatically.

	{{#document collection="csvImport"}}
		<form no-auto-update>
			<input name="columnName" value="{{columnname}}"> //the input field must have the same name as the field that sould be updated
			<input type="Submit" href="index"> // the form ignores the action, so you instead set an href on the input.
		</form>
	{{/collection}}

Notice the `no-auto-update`, if it is not set autosave without the need to submit.

### actions to change data

You can change data by using view-helpers that will attach click events. They will
update session or documentant variables.

	// Set a textfield:
	<button {{actionSet "someField" "Hello"}}>Say hello</button>

	// Set a boolean field
	<button {{actionSetBoolean "someField" true}}>On</button>
	<button {{actionSetBoolean "someField" false}}>Off</button>

	// Toggle a boolean field (needs to be in quotes)
	<button {{actionSetBoolean "someField" "toggle"}}>Toggle</button>

	// Increment a number (can be negative)
	<button {{actionIncrement "votes" 1}}>+1</button>


### Changing data with forms

Form data is always automatically saved. It does not persist across reloads. If the form is enclosed by a {{#repeat}} helper with a collection or a document, form data is saved to the corresponding document.

#### Session data with Textinputs

	<input type="text" name="phoneNumber">
	<p>{{session "phoneNumber"}}</p>

Any input entered into an input field, will be saved to a session variable with name that is the same as the id or the name of the input (id has priority). This works for

#### Selects

	<select class="browser-default" name="selectValue">
		<option value="" disabled selected>Choose your option</option>
		<option value="1">Option 1</option>
		<option value="2">Option 2</option>
		<option value="3">Option 3</option>
	</select>
	{{session "selectValue"}}

#### Textareas

	<textarea type="text" name="comment">{{session "comment"}}</textarea>
	<p>{{simpleFormat (session "comment")}}</p>

	or have fun with markdown

	{{#markdown}}
		{{ session "comment"}}
	{{/markdown}}

#### Checkboxes

	<input type="checkbox" id="happy" name="happy" />
	<label for="happy">Happy</label>
	{{session "happy"}}

#### Forms with namespacing

	<form name="contact">
		Name <input type="text" name="name">
		PhoneNumber <input type="text" name="phoneNumber">
		<p>{{session "contact.name"}} {{session "contact.phoneNumber"}}</p>
	</form>

This will save any input in the form to the session prepended by the name of the form. Agains this data is availble across the whole application.

To prevent autosave add the `no-auto-update`-Attribute to the form:

	<form name="contact" no-auto-update> ...

### Forms for documents

If you are using Collections or Documents, instead of saving the data to the session, it saved it to the collection or document instead.

	{{#repeat collection="contacts" create="10"}}
		{{field name="name" random="name"}} {{#if selected}}(selected){{/if}}<br>
		<input type="checkbox" name="selected">
		<input type="text" name="name" value="{{name}}">
		<hr>
	{{/repeat}}

## Repeat

Repeat is a very powerful helper, you can use it very simply. To repeat a block 10 times:

	{{#repeat limit="10"}}
		block
	{{/repeat}}

To repeat with certain values you can  repeat the block once for every comma separated value given by ´with´. ´{{ this }}´ will be replaced by the current comma separated value. (cannot be mixed with limit)

	{{#repeat with="A,B,C"}}
		block {{ this }}
	{{/repeat}}

But repeat blocks can also be real collections of data, see [collections](#collections)

	{{#repeat collection="contacts"}}
		{{name}}
	{{/repeat}}

## Data

	{{random 'name'}}

Will return a random combinations of a first name and a family name. Other options are:

	{{random 'firstName'}}
	{{random 'familyName'}}
	{{random 'phoneNumber'}}
	{{random 'email'}}

more to come... (dates, birthdays)

### Pick

	{{pick 'The Alliance, The Rebels, Neutral'}}

Will return one of the comma-separated options.

## Viewhelpers

### Collections

    {{#repeat collection='people' create=100 sort='name' limit='10'}}
      block
			{{else}}
			show else blockthis if collection is empty because of filters or other reasons
    {{/repeat}}

The `repeat` block helper allows use of realistic data in your views. The block within the collection is repeated for all `documents` in you dataset. Datasets are created by importing data via CSV or YAML files or you can create documents directly with the repeat helper.

#### options

create=`integer`
: `create` pass an integer to create as many empty documents for this collection. example: `create=100`

sort=`"fieldName"`
:`sort` takes a fieldName by which the collection will be sorted. Example: `sort="name"`. WARNING: if you combine sorting and content generation by {{field ...}} in a view it may lead to whacky behavior, data is created and sorted at the same time.

limit=`integer`
:`limit` will limit the displayed number of documents. Example: `limit=10`

#### Nested colllections

You can nest collections by using the id of the parent to create a new collection:

```
	{{#repeat collection="nested" create=10}}
		 {{field "name" random="name"}}
		 {{#repeat collection=_id create=3}}
			 <small>{{field "name" random="name"}}</small>
		 {{/repeat}}
		 <hr>
	{{/repeat}}
```

### Field

    {{field name="phoneNumber"}}

This helper displays the value of a field from a document. It is only to be used within a `collection` or `document` helper. It can be used to create data for documents on the fly.

    {{#repeat name='people' create='10'}}
        {{field name='name' random="name"}}<br> // will give you a random first name
        {{field name='category' pick="friend,family"}} // will return a random pick
    {{/repeat}}

This will output a list of 10 names (only if you assign it a random or a pick attribute). **This data is saved and will not change, if you switch between pages.** However if you reload a page, the collections are reset.

#### options

##### random=`randomOption`

`random` will assign a random value, if it has no value and if you pass it a valid randomOption like name, firstName, familyName, phoneNumber or email.

##### pick=`comma,separated,list`

`pick` will assign a random pick out of the comma-separated list you pass to it, unless the data is already set.


### Session

    {{session "someSessionVariable" "defaulValue"}}

`session` displays the current value of a sessionVariable. If there is no value set it displays the `defaultValue` (optional).

#### helpful session variables set by jeizinen

* `filters` If you set a filter for a collection you can get the currently set value by: {{session "filters.collection.field"}}



## Filtering Collections

Filter a collection by using the `filter`-helper in a an html-element.

	<a {{filter collection="collectionName" field="fieldName" value="string"}}

If this element is clicked, the collection will be filtered by searching for documents that have the value "string" in the field "fieldname". The filtering will persist across page switches. To show all elements again you reset by filtering with `value=""`.

<!--
## Get images

	<img data-search="dolphins">

Image tags with the attribute `data-search` will automatically point to a flickr image that fits the search string.
-->
<!-- I think this currently does not work
## Flash Messages

If you include the `{{> flashMessages }}`-template somehwere you can display messages.
Messages use the [bootstrap-3 alert-classes](http://getbootstrap.com/components/#alerts): just pass 'success', 'info' or 'danger' to style the message.

### via data attributes

	<a href="..." data-flash-message="This is good!" data-flash-message-type="success">

When you click on this link, it will show:

<div class="alert alert-success">This is good!</div>


-->
<!-- If you a picture does not fit your need, alt-click on it, it will be replaced by the next one.
 -->

## Some utilities

#### hyphenate

	{{hyphenate "some string"}}

returns some-string, helpful for turning strings form model in to css classes

	{{modulo number divider}}

returns modulo, helpful for image placeholder services that offer limited numer of direct id pictures like http://pravatar.cc/

## Helpful resources

### Recommended Image Placeholders

```
		<img src="http://placehold.it/100x100" alt=""  class="responsive-img"
		style="object-fit: cover; width: 100px; height: 100px"/>
		<img src="http://i.pravatar.cc/150?img={{modulo _index 49}}" alt=""  class="responsive-img circle"
		style="object-fit: cover; width: 100px; height: 100px"/>
		<img src="http://lorempixel.com/400/200/sports/{{_index}}" alt=""  class="responsive-img"
		style="object-fit: cover; width: 100px; height: 100px"/>
```
 {{_index}} will only be available in repeats or documents


{%endraw %}
