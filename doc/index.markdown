The FastAtlas API
==================

This is an implementation of the Atlas API that is tuned for read performance. If it was hosted on local servers, nearly all responses would be sub-second.  It is currently hosted on Heroku, meaning most responses are served in 1-2 seconds.

What can it do?
==================================

**Give me all restaurants within 1km of Southbank**  
[pois?where[close_to]=-37.821836,144.960029,1000&where[type]=eat](/pois?where[close_to]=-37.821836,144.960029,1000&where[type]=eat)  
Atlas: Not implemented  
FastAtlas: 1-2 seconds

**Give me just the name and id of all Italy POIs that aren't geocoded**  
[pois?select=name&where[place]=359845&where[geocoded]=false](/pois?select=name&where[place]=359845&where[geocoded]=false)  
Atlas: Not implemented  
FastAtlas: 1-2 seconds

**Give me all places that contain the lat long of Eiffel Tower**  
[places?where[contains_point]=48.8582493546056,2.294511795044](/places?where[contains_point]=48.8582493546056,2.2945117950440)  
Atlas: Not implemented  
FastAtlas: 1 second

**Give me 1000 places**  
[places?limit=1000](/places?limit=1000)  
Atlas: 30-40 seconds  
FastAtlas: 1-2 seconds
  
**Give me 1000 POIs in Australia**  
[pois?where[place]=362249&limit=1000](/pois?where[place]=362249&limit=1000)  
Atlas: 30-40 seconds  
FastAtlas: 1-2 seconds

**Give me only the names and ids of ALL the POIs in Australia**  
[pois?select=name&where[place]=362249&limit=12000](/pois?select=name&where[place]=362249&limit=12000)  
Atlas: 12 pages of 1000 POIs takes around 6-8 minutes  
FastAtlas: 2-3 seconds
   
**Give me all POIs in a bounding box**  
[pois?where[contained_in]=38.079598,37.479598,-122.120143,-122.720143](/pois?where[contained_in]=38.079598,37.479598,-122.120143,-122.720143)  
Atlas: 20-25 seconds  
FastAtlas: 1-2 seconds

**Get 1000 POIs in a place, with reviews**  
[pois?where[place]=362494&limit=1000&detailed=true](/pois?where[place]=362494&limit=1000&detailed=true)  
Atlas: 40-50 seconds  
FastAtlas: 3-5 seconds

Why is it faster?
===============
* It is implemented only in JSON. XML should be considered for deprecation in the existing API.
* It is implemented in Ruby 1.9.2 and Rails 3.0.6, taking advantages of the performance boosts over Ruby 1.8.7 and Rails 2.3.2
* The database it uses for its backend is a denormalized version of the existing Atlas data.  There are two tables: pois & places.
* The JSON returned has all whitespace removed, making it less human readable but much smaller and faster.
* It focusses on doing only one thing.

Extra Features/Changes
======================
* "**Show me all POIs within a certain distance of a place**" - so you can find all restaurants within 1km of Southbank
* "**Let me choose the fields I want returned**" - you might want 'name' but not 'etyhl_id', so you can omit ethyl_id to improve performance more.
* "**Show me all places that contain this point**" - give a lat/long and you can find out all places that contain that point
* Getting all POIs for a place now uses `pois/where[place]=1006242` instead of `places/1006242/pois`
* If a field is null, then it is not returned in the JSON.  So if a field is not returned, you can be sure it is null.  This is to reduce response size.

Missing Features
================
* No search for POIs by ISBN. To get this data denormalised was going to take longer than a weekend.
* No posting data.  The data is read-only.
* No support for multiple languages
* No versioning (draft/published).  The latest version (in its default language) of each POI/Place in Atlas was used to seed the database.
* No tests. No good error handling.  Bit of a hack really.

Places API
==========

### List places

    GET /places

#### Options

* Exact name match: [where\[name\]=Elbow Cay](/places?where[name]=Elbow%20Cay)
* Pattern name match: [where\[name\]=Elb\*](/places?where[name]=Elb*)
* Limit response to 10 results: [limit=10](/places?limit=10)
* Skip the first 20 results: [offset=20](/places?offset=20)
* By id: [where\[id\]=362494](/places?where[id]=362494)
* By parent: [where\[parent\]=362494](/places?where[parent]=362494)
* Contains point: [where\[contains\_point\]=lat,long](/places?where[contains_point]=48.8582493546056,2.294511795044)

POIs API
========

### List POIs
    
    GET /pois
    
#### Options

* Exact name match: [where\[name\]=Eiffel Tower](/pois?where[name]=Eiffel%20Tower)
* Pattern name match: [where\[name\]=Eif\*](/pois?where[name]=Eif*)
* Limit response to 10 results: [limit=10](/pois?limit=10)
* Skip the first 20 results: [offset=20](/pois?offset=20)
* Find all POIs in a place [where\[place\]=362494](/pois?where[place]=362494)
* Bounding box: [where\[contained\_in\]=n,s,e,w](/pois?where[bounding_box]=50,40,20,-20)
* Poi Type (Eat | Sleep | Night | See | Shop | Do | General | Go): [where\[type\]=Eat](/pois?where[type]=Eat)
* Full detail. Default is summary: [detailed=true](/pois?limit=10&detailed=true)
* Within a certain number of metres to a point: [where\[close\_to\]=lat,long,metres](/pois?where[close_to]=-37.821836,144.960029,1000)
* If geocoded (has lat/long): [where\[geocoded\]=true/false](pois?where[geocoded]=false)
