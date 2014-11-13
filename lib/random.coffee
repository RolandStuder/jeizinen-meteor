UI.registerHelper "random", (dataType, options) -> # deprecated, use mock now...
  data = random(dataType,options.hash)
  new Handlebars.SafeString(data)

UI.registerHelper "pick", (commaSeparatedList) -> 
  data = pick commaSeparatedList
  new Handlebars.SafeString(data)


sample = (array) ->
  array[Math.floor(Math.random() * array.length)]

@pick = (string) ->
  sample string.split(",")

@random = (dataType, options) ->
  if !options then options = {}
  switch dataType
    when 'name'
      random('firstName') + " " + random('familyName')
    when 'firstName'
      sample ["Allison", "Arthur", "Ana", "Alex", "Arlene", "Alberto", "Barry", "Bertha", "Bill", "Bonnie", "Bret", "Beryl", "Chantal", "Cristobal", "Claudette", "Charley", "Cindy", "Chris", "Dean", "Dolly", "Danny", "Danielle", "Dennis", "Debby", "Erin", "Edouard", "Erika", "Earl", "Emily", "Ernesto", "Felix", "Fay", "Fabian", "Frances", "Franklin", "Florence", "Gabielle", "Gustav", "Grace", "Gaston", "Gert", "Gordon", "Humberto", "Hanna", "Henri", "Hermine", "Harvey", "Helene", "Iris", "Isidore", "Isabel", "Ivan", "Irene", "Isaac", "Jerry", "Josephine", "Juan", "Jeanne", "Jose", "Joyce", "Karen", "Kyle", "Kate", "Karl", "Katrina", "Kirk", "Lorenzo", "Lili", "Larry", "Lisa", "Lee", "Leslie", "Michelle", "Marco", "Mindy", "Maria", "Michael", "Noel", "Nana", "Nicholas", "Nicole", "Nate", "Nadine", "Olga", "Omar", "Odette", "Otto", "Ophelia", "Oscar", "Pablo", "Paloma", "Peter", "Paula", "Philippe", "Patty", "Rebekah", "Rene", "Rose", "Richard", "Rita", "Rafael", "Sebastien", "Sally", "Sam", "Shary", "Stan", "Sandy", "Tanya", "Teddy", "Teresa", "Tomas", "Tammy", "Tony", "Van", "Vicky", "Victor", "Virginie", "Vince", "Valerie", "Wendy", "Wilfred", "Wanda", "Walter", "Wilma", "William", "Kumiko", "Aki", "Miharu", "Chiaki", "Michiyo", "Itoe", "Nanaho", "Reina", "Emi", "Yumi", "Ayumi", "Kaori", "Sayuri", "Rie", "Miyuki", "Hitomi", "Naoko", "Miwa", "Etsuko", "Akane", "Kazuko", "Miyako", "Youko", "Sachiko", "Mieko", "Toshie", "Junko"]

    when 'familyName'
      sample ["Smith", "Johnson", "Williams", "Jones", "Brown", "Davis", "Miller", "Wilson", "Moore", "Taylor", "Anderson", "Thomas", "Jackson", "White", "Harris", "Martin", "Thompson", "Garcia", "Martinez", "Robinson", "Clark", "Rodriguez", "Lewis", "Lee", "Walker", "Hall", "Allen", "Young", "Hernandez", "King", "Wright", "Lopez", "Hill", "Scott", "Green", "Adams", "Baker", "Gonzalez", "Nelson", "Carter", "Mitchell", "Perez", "Roberts", "Turner", "Phillips", "Campbell", "Parker", "Evans", "Edwards", "Collins", "Stewart", "Sanchez", "Morris", "Rogers", "Reed", "Cook", "Morgan", "Bell", "Murphy", "Bailey", "Rivera", "Cooper", "Richardson", "Cox", "Howard", "Ward", "Torres", "Peterson", "Gray", "Ramirez", "James", "Watson", "Brooks", "Kelly", "Sanders", "Price", "Bennett", "Wood", "Barnes", "Ross", "Henderson", "Coleman", "Jenkins", "Perry", "Powell", "Long", "Patterson", "Hughes", "Flores", "Washington", "Butler", "Simmons", "Foster", "Gonzales", "Bryant", "Alexander", "Russell", "Griffin", "Diaz", "Hayes"]

    when 'phoneNumber'
      phoneNumber  = "+" + random('integer', {from: '1', to: '99'})
      phoneNumber += " (" + random('integer', {from: '10', to: '99'}) + ")"
      phoneNumber += " " + random('integer', {from: '100', to: '999'})
      phoneNumber += " " + random('integer', {from: '10', to: '99'})
      phoneNumber += " " + random('integer', {from: '10', to: '99'})

    when 'email'
      random.firstName() + "." + random.familyName() + "@" + random.pick(options: "example,gmail,yahoo,bigcorp") + ".com"

    when 'integer'
      if options.from then lowerLimit = options.from else lowerLimit = 1
      if options.to   then upperLimit = options.to   else upperLimit = 100
      Math.floor(upperLimit - (Math.random() * (upperLimit - lowerLimit + 1))) + 1