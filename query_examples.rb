IO_EVENT_SERVER_URL=http://35.164.106.171:7070
PIO_ENGINE_URL=http://35.164.106.171:8000
PIO_ACCESS_KEY=FeST0jPZ4pvoXzJuen5pHeSusBw0IUcj8ISQ1USuQtR6onwBm9Bv3h4TGtScLr1l

----------------------------------------------------------------------------
NEw User -> event server :
# Create a client object.
client = PredictionIO::EventClient.new(<ACCESS KEY>, <URL OF EVENTSERVER>)

# Create a new user
client.create_event(
  '$set',
  'user',
  <USER ID>
)
-----------------------------------------------------------------------------
Get personalized recommendation:

# Create client object.
client = PredictionIO::EngineClient.new($PIO_ENGINE_URL)

# Query PredictionIO.
response = client.send_query('user' => ['user_ID'], 'num' => 25)

puts response
-------------------------------------------------------------------------------

Get similar product recommendation

# Create client object.
client = PredictionIO::EngineClient.new($PIO_ENGINE_URL)

# Query PredictionIO.
response = client.send_query('item' => ['item_ID'], 'num' => 25)

puts response

-------------------------------------------------------------------------------



Get Contextual Personalized (neu user co chon genres ho thich)

{
  “user”: “userID”,
  “fields”: [
    {
      “name”: "categories",
      “values”: [“series”, “mini-series”], // For example -  List of Genres user does not like
      “bias”: -1 // filter out all except ‘series’ or ‘mini-series’
    },{
      “name”: "categories",
      “values”: [“sci-fi”, “detective”], // For example  - List of Genres user like
      “bias”: 1.02          // boost/favor recommendations with the `genre’ = `sci-fi` or ‘detective’
    }
  ]
}

EX1 :

curl -H "Content-Type: application/json" -d ' 
{"user":"92",
"fields":[{"name":"categories","values":["Horror"],"bias":-1},
{"name":"categories","values":["Children"],"bias":1.02}]
}' http://35.164.106.171:8000/queries.json


--------------------------------------------------------------------



Contextual Personalized With Similar Items ID = xxx

{
  “user”: “user_ID”, 
  "userBias": 2, // favor personal recommendations
  “item”: “item_ID”, // fallback to contextual recommendations
  “fields”: [
    {
      “name”: "categories",
      “values”: [“series”, “mini-series”,"categoryName"], // List of genres that user does not like
      “bias”: -1 }// filter out all except ‘series’ or ‘mini-series’ // For example
    },{
      “name”: “genre”,
      “values”: [“sci-fi”, “detective”], // List of genres that user like
      “bias”: 1.02 // boost/favor recommendations with the `genre’ = `sci-fi` or ‘detective’
    }
  ]
}

EX:
curl -H "Content-Type: application/json" -d ' 
{"user":"92","userBias":2,"item":"593"
"fields":[{"name":"categories","values":["Horror"],"bias":-1},
{"name":"categories","values":["Children"],"bias":1.02}]
}' http://35.164.106.171:8000/queries.json



----------------------- genres 
Action	
Adventure
Animation	
Biography
Comedy
Crime
Documentary	
Drama
Family	
Fantasy	
Game-Show
History
Horror
Music
Musical
Mystery
News	
Reality-TV
Romance	
Sci-Fi
Sitcom
Sport	
Talk-Show
Thriller
War	
Western
----------------------------------------





fulll query name :
{
  “user”: “92”, 
  “userBias”: -maxFloat..maxFloat,
  “item”: “53454543513”, 
  “itemBias”: -maxFloat..maxFloat,  
  “num”: 4,
  "fields”: [
    {
      “name”: ”fieldname”
      “values”: [“fieldValue1”, ...],
      “bias”: -maxFloat..maxFloat 
    },...
  ]
  "dateRange": {
    "name": "dateFieldname",
    "before": "2015-09-15T11:28:45.114-07:00",
    "after": "2015-08-15T11:28:45.114-07:00"
  },
  "currentDate": "2015-08-15T11:28:45.114-07:00",
  “blacklistItems”: [“itemId1”, “itemId2”, ...]
  "returnSelf": true | false,
}
