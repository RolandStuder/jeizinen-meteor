// Supercollection MockData will eat anything...
// warning will only work within templates...

MockData = new Meteor.Collection('MockData');

empty = " ";


MockData.createCollection = function(name) {
	var newCollection = {}
	if (!MockData[name]) newCollection[name] = new Meteor.Collection(null);
	_.extend(MockData,newCollection);
}

MockData.insert = function(collection, data) { // use custom insert so mock helper, knows which colleciton the item belongs to
	if(!MockData[collection]) createCollection('collection');
	data['collection'] = collection;
	data['createdAt'] = new Date().getTime();
	return MockData[collection].insert(data);
}

if (Meteor.isClient) {
	Handlebars.registerHelper('mockData',function(options){
		var collectionName = options.hash['collection']
		MockData.createCollection(collectionName);
		
		if( !options.hash['amount']) {options.hash['amount'] = '10'}
		
		var result = "";
		
		if (MockData[collectionName].find().count()===0) {
			for (var i=0; i<options.hash['amount']; i++) {
				var item = MockData[collectionName].insert({collection: collectionName});
			}
		} 

		MockData[collectionName].find({},{sort: {'createdAt': -1}}).forEach(function(item){
			result += options.fn(item);
		})
			
		return result
	})

	// updateField = function(collection, id, field, value) {
	// 	console.log(collection + id + field + value);
	// 	MockData[collection].update(id,{$set: {field: value}});
	// }

	Handlebars.registerHelper('mock',function(dataType,options){
		id = this._id;
		collection = this.collection;
		item = MockData[this.collection].findOne(id);
		if (options.hash.field) { fieldName = options.hash.field } else { fieldName = dataType }
		if (!item[fieldName]) {
			result = random[dataType](options.hash);
			data = {}
			data[fieldName] = result;
			MockData[this.collection].update(id,{$set: data});
		} else {
			result = item[fieldName];
		}

		result = new Handlebars.SafeString(result);
  		return result;
	});
}

var updateEntry = function(form) { // TODO: does not work right now, data seem to come back empty....
	var inputs = $(form).find('input[name]');
	Mock = form;
	console.log(form);
	var data = {};
	inputs.each(function(index){
		console.log(this)
		data[$(this).attr('name')] = $(this).val()
		$(this).val('');
	});
	console.log(data);
	var collectionName = $(form).attr('data-collection');
	MockData.createCollection(collectionName);
	dataId = $(form).attr('data-id');
	if (MockData[collectionName].findOne(dataId) ) {
		MockData[collectionName].update(dataId,{$set: data})
	} else {
		newEntry = MockData.insert(collectionName,data);

	}
	// FlashMessages.display('success','Saved' + newEntry);
	console.log(data);
}

if (Meteor.isClient) {
	Meteor.startup(function(){
		$('body').on('submit','form', function(e){
			e.preventDefault();
			updateEntry(this);
		})
	});

}