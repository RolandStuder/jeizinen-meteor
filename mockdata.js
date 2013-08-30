// Supercollection MockData will eat anything...
// warning will only work within templates...

MockData = new Meteor.Collection('MockData');

empty = " ";


MockData.createCollection = function(name) {
	var newCollection = {}
	if (!MockData[name]) newCollection[name] = new Meteor.Collection(null);
	_.extend(MockData,newCollection);
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

		MockData[collectionName].find({},{reactive: false}).forEach(function(item){
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

		if (!item[dataType]) {
			// Meteor.setTimeout(updateField(collection,id,dataType,result),1000)
			result = random[dataType](options);
			data = {}
			data[dataType] = result;
			MockData[this.collection].update(id,{$set: data});
		} else {
			result = item[dataType];
		}

		// if(Deps.active) {
		// 	console.log("not active")
		// }
		
		// console.log(item[dataType]);
		// console.log(this.collection);

		// Deps.afterFlush(function(){
		// 	console.log(this.collection);
		// 	console.log(MockData[this.collection]);
		// 	updateField(collection,id,dataType,result)
		// 	// MockData[this.collection].update(id,{$set: {dataType: result}});
		// })
		// MockData[this.collection].update(id,{$set: {dataType: result}});
		// Deps.afterFlush(function(){
		// 	field = !item[dataType];
		// })
		// if (field) {
		// 	result = random[dataType](options);
		// 	// data = ;	
		// 	MockData[this.collection].update(id,{$set: {dataType: result}})
		// }
		// result = result[dataType];
		// if(item = MockData[this.collection].findOne(this._id)) {
		// 	result = item[dataType]; 
		// } else {
		// 	result = random[dataType](options);
		// 	collection = this.collection;
		// 	id = this._id;
		// 	// MockData[collection].update({id}, {$set: {dataType: result}} )
		// }
		result = new Handlebars.SafeString(result);
  		return result;
	});
}

// var updateEntry = function(form) { // TODO: does not work right now, data seem to come back empty....
// 	var inputs = $(form).find('input[name]');
// 	Mock = form;
// 	console.log(form);
// 	var data = {};
// 	inputs.each(function(index){
// 		data[$(form).attr('name')] = $(form).val()
// 	});
// 	var collectionName = $(form).attr('data-collection');
// 	if (!MockData[collectionName]) { MockData.createCollection(collectionName) }
// 	newEntry = MockData[collectionName].insert(data);
// 	FlashMessages.display('success','Saved' + data);
// 	console.log(data);
// }

// if (Meteor.isClient) {
// 	Meteor.startup(function(){
// 		$('body').on('submit','form', function(e){
// 			e.preventDefault();
// 			updateEntry(this);
// 		})
// 	});

// }