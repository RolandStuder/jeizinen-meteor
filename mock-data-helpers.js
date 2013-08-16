Handlebars.registerHelper('random', function(dataType, options) {
  data = random(dataType, options)
  return new Handlebars.SafeString(data);
});

random = function random (dataType, options) {
	if (dataType == "name") {
		return getFirstName() + " " + getFamilyName(); 
	} else if (dataType == "firstName") {
		return getFirstName();
	} else if (dataType == "familiyName") {
		return getFamilyName();
	} else if (dataType == "phoneNumber") {
		return getPhoneNumber();
	} else {
		throw new Meteor.Error(500, "jeizinen:: unknown dataType for random-helper, check http://rolandstuder.github.io/jeizinen-meteor/#mockdata for valid dataTypes");
		return "nothing here"
	}
};

getFirstName = function() {
	return sample(['Allison', 'Arthur', 'Ana', 'Alex', 'Arlene', 'Alberto', 'Barry', 'Bertha', 'Bill', 'Bonnie', 'Bret', 'Beryl', 'Chantal', 'Cristobal', 'Claudette', 'Charley', 'Cindy', 'Chris', 'Dean', 'Dolly', 'Danny', 'Danielle', 'Dennis', 'Debby', 'Erin', 'Edouard', 'Erika', 'Earl', 'Emily', 'Ernesto', 'Felix', 'Fay', 'Fabian', 'Frances', 'Franklin', 'Florence', 'Gabielle', 'Gustav', 'Grace', 'Gaston', 'Gert', 'Gordon', 'Humberto', 'Hanna', 'Henri', 'Hermine', 'Harvey', 'Helene', 'Iris', 'Isidore', 'Isabel', 'Ivan', 'Irene', 'Isaac', 'Jerry', 'Josephine', 'Juan', 'Jeanne', 'Jose', 'Joyce', 'Karen', 'Kyle', 'Kate', 'Karl', 'Katrina', 'Kirk', 'Lorenzo', 'Lili', 'Larry', 'Lisa', 'Lee', 'Leslie', 'Michelle', 'Marco', 'Mindy', 'Maria', 'Michael', 'Noel', 'Nana', 'Nicholas', 'Nicole', 'Nate', 'Nadine', 'Olga', 'Omar', 'Odette', 'Otto', 'Ophelia', 'Oscar', 'Pablo', 'Paloma', 'Peter', 'Paula', 'Philippe', 'Patty', 'Rebekah', 'Rene', 'Rose', 'Richard', 'Rita', 'Rafael', 'Sebastien', 'Sally', 'Sam', 'Shary', 'Stan', 'Sandy', 'Tanya', 'Teddy', 'Teresa', 'Tomas', 'Tammy', 'Tony', 'Van', 'Vicky', 'Victor', 'Virginie', 'Vince', 'Valerie', 'Wendy', 'Wilfred', 'Wanda', 'Walter', 'Wilma', 'William', 'Kumiko', 'Aki', 'Miharu', 'Chiaki', 'Michiyo', 'Itoe', 'Nanaho', 'Reina', 'Emi', 'Yumi', 'Ayumi', 'Kaori', 'Sayuri', 'Rie', 'Miyuki', 'Hitomi', 'Naoko', 'Miwa', 'Etsuko', 'Akane', 'Kazuko', 'Miyako', 'Youko', 'Sachiko', 'Mieko', 'Toshie', 'Junko']);
}

getFamilyName = function() {
	return sample(['Smith', 'Johnson', 'Williams', 'Jones', 'Brown', 'Davis', 'Miller', 'Wilson', 'Moore', 'Taylor', 'Anderson', 'Thomas', 'Jackson', 'White', 'Harris', 'Martin', 'Thompson', 'Garcia', 'Martinez', 'Robinson', 'Clark', 'Rodriguez', 'Lewis', 'Lee', 'Walker', 'Hall', 'Allen', 'Young', 'Hernandez', 'King', 'Wright', 'Lopez', 'Hill', 'Scott', 'Green', 'Adams', 'Baker', 'Gonzalez', 'Nelson', 'Carter', 'Mitchell', 'Perez', 'Roberts', 'Turner', 'Phillips', 'Campbell', 'Parker', 'Evans', 'Edwards', 'Collins', 'Stewart', 'Sanchez', 'Morris', 'Rogers', 'Reed', 'Cook', 'Morgan', 'Bell', 'Murphy', 'Bailey', 'Rivera', 'Cooper', 'Richardson', 'Cox', 'Howard', 'Ward', 'Torres', 'Peterson', 'Gray', 'Ramirez', 'James', 'Watson', 'Brooks', 'Kelly', 'Sanders', 'Price', 'Bennett', 'Wood', 'Barnes', 'Ross', 'Henderson', 'Coleman', 'Jenkins', 'Perry', 'Powell', 'Long', 'Patterson', 'Hughes', 'Flores', 'Washington', 'Butler', 'Simmons', 'Foster', 'Gonzales', 'Bryant', 'Alexander', 'Russell', 'Griffin', 'Diaz', 'Hayes']);
};

getPhoneNumber = function() {
	return "+" + randomInteger(1,99) + " (" + randomInteger(10,99) + ") " + randomInteger(100,999) + " " + randomInteger(10,99) + " " + randomInteger(10,99);
};

var sample = function(array) {
	return array[Math.floor(Math.random() * array.length)];
};

var randomInteger = function(lower_limit, upper_limit) {
	return Math.floor(upper_limit - (Math.random() * (upper_limit - lower_limit+1)))+1;
}

Handlebars.registerHelper('pickOne', function(string) {
  choices = string.split(",") ;
  data = sample(choices);
  return new Handlebars.SafeString(data);
});