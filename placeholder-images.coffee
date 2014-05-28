# // stuff to make sure, we don't add another pool of images just because the subscription are not completed yet...
checkIfCollectionIsReady = ->
  console.log "checking..."
  if PlaceholderImages.findOne()
    Meteor.clearInterval waitForCollection
    replacePlaceholders()
  return

initializeCollectionWithDocument = ->
  if PlaceholderImages.find({}).count() is 0
    console.log "placeholderImages initialized...."
    PlaceholderImages.insert comment: "intialize, necessery because I cannot check if a collection is truly empty while using autosubscribe"
  return

createImagePoolDocument = (query, photoArray) ->
  if photoArray.length > 0
    PlaceholderImages.insert
      query: query
      photos: photoArray

    console.log "Images for '" + query + "'' added to image pool"
    replaceNow()
  else
    console.log "not getting any pictures, change your search and try again"
  return

getFlickrImages = (query) ->
  console.log "getting pictures from flickr..."
  $.ajax
    url: "http://ycpi.api.flickr.com/services/rest/"
    data:
      api_key: "1a02addb94c985970bca4339af022b01"
      format: "json"
      method: "flickr.photos.search"
      license: "4,5,6,7" # All NC Licenses
      text: query
      safe_search: 3
      sort: "relevance"

    dataType: "jsonp"
    jsonp: "jsoncallback"
    success: (response) ->
      createImagePoolDocument query, response.photos.photo
      return

  return

replaceNow = (placeholders)->
  queryCounter = {}
  $(placeholders).each (index) ->
    query = $(this).attr("data-search")
    photos = PlaceholderImages.findOne(query: query).photos
    if queryCounter[query] is `undefined`
      queryCounter[query] = 0
    else if queryCounter[query] > photos.length - 2
      queryCounter[query] = 0
    else
      queryCounter[query]++
    currentPhoto = photos[queryCounter[query]]
    photoURL = "http://farm" + currentPhoto.farm + ".staticflickr.com/" + currentPhoto.server + "/" + currentPhoto.id + "_" + currentPhoto.secret + ".jpg"
    $(this).attr "src", photoURL
    $(this).attr "placeholder-position", "" + queryCounter[query]
    return

  return

@replacePlaceholders = ->
  placeholders = $($("img[data-search]").get().reverse())
  uniqueQueries = []
  placeholders.each -> # get unique queries
    query = $(this).attr("data-search")
    uniqueQueries.push query  if $.inArray(query, uniqueQueries) is -1
    return

  $(uniqueQueries).each (index, value) ->
    # i think this check is no longer necessary
    getFlickrImages value  unless PlaceholderImages.findOne(query: value)  if PlaceholderImages.find({}).count() > 0 # somehome !findOne... messed this up
    return

  replaceNow(placeholders)
  return


# alt+click lets you remove an image from an image pool
enableRemovalOfPlaceholders = ->
  remove = (image) ->
    image = $(image)
    query = image.attr("data-search")
    pool = PlaceholderImages.findOne(query: query)
    photos = pool.photos
    photos.splice image.attr("placeholder-position"), 1
    if photos.length is 0
      PlaceholderImages.remove pool._id
    else
      PlaceholderImages.update pool._id,
        $set:
          photos: photos

      replaceNow()
    return

  
  # delegated binding...
  $("body").on "click", "img[data-search]", (e) ->
    remove this  if e.altKey
    return

  return

Meteor.startup ->
  Meteor.setTimeout initializeCollectionWithDocument, 5000
  enableRemovalOfPlaceholders()
  
  # Main function is called when a template is rendered
  @replaceImagePlaceholders = ->
    if $("img[data-search]").length
      unless PlaceholderImages.findOne()
        @waitForCollection = Meteor.setInterval(checkIfCollectionIsReady, 1000)
      else
        replacePlaceholders()
    return
  return
