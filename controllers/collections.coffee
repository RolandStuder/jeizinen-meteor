# Supercollection Collection will eat anything...
# warning will only work within templates...

@Collections = new Meteor.Collection("Collection")

Collections.create = (name) ->
  newCollection = {}
  newCollection[name] = new Meteor.Collection(null)  unless Collections[name]
  _.extend Collections, newCollection

Collections.createEmptyItems = (name, amount) ->
  if Collections[name].find().count() is 0
      for i in [0...amount] by 1
        item = Collections.insert(name,{collection: name})

Collections.insert = (collection, data) -> # use custom insert so mock helper, knows which collection the item belongs to
  create "collection"  unless Collections[collection]
  data["collection"] = collection
  data["createdAt"] = new Date().getTime()
  Collections[collection].insert data


if Meteor.isClient

  Handlebars.registerHelper "collection", (options) ->
    name = options.hash['name']
    amount = options.hash['create']
    Collections.create name
    if amount
      Collections.createEmptyItems(name, amount)
    result = ""
    Collections[name].find({},sort: createdAt: -1).forEach (item) ->
      result += options.fn(item)
    result

  Handlebars.registerHelper "field", (field, options) ->
    if @_id
      name = this.collection
      data = {}
      if this[field]
        data[field] = this[field]
      else if options.hash['random']
        data[field] = random(options.hash['random'],options.hash)
        Collections[name].update @_id,{$set: data}
      else if options.hash['pick'] 
        data[field] = pick options.hash['pick']
        Collections[name].update @_id,{$set: data}
      else
        data[field] = random(field)
        Collections[name].update @_id,{$set: data}
      data[field]


#   # updateField = function(collection, id, field, value) {
#   #   console.log(collection + id + field + value);
#   #   Collection[collection].update(id,{$set: {field: value}});
#   # }


# @updateEntry = (form) ->
#   inputs = $(form).find("input[name]")
#   Mock = form
#   data = {}
#   inputs.each (index) ->
#     data[$(this).attr("name")] = $(this).val()
#     $(this).val ""

#   collectionName = $(form).attr("data-collection")
#   Collection.create collectionName
#   dataId = $(form).attr("data-id")
#   if Collection[collectionName].findOne(dataId)
#     Collection[collectionName].update dataId,
#       $set: data

#   else
#     newEntry = Collection.insert(collectionName, data)

# Meteor.isClient

# Meteor.startup(function(){
#   $('body').on('submit','form', function(e){
#     e.preventDefault();
#     updateEntry(this);
#   })
# });

# enableClickActions = function() {
#   $('body').on('click', '[data-onClick-setTrue]', function(e){
#     _id = $(this).attr('data-id');
#     Collection['people'].update(_id, {$set: {isEdit: true}}) // problem seems to by, that add time of binding, these things are not defined

#     // console.log(this)
#     // replaceTemplate = $(this).attr('data-replace-with-template');
#     // id = $(this).attr('data-target');
#     // replaceTemplate = Template['people-edit']();
#     // selector = "#"+id.to_s;
#     // $(selector).replaceWith('test');
#   })
# }