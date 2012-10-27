# What is this#
Uses a graph database to store information, with all information either represented as an object or a relationship between objects, for example:

    dog                                    is_a                                     animal
      access_count: 5                         access_count: 123                        access_count: 43
      created_at: now.addYears(-5)   -->>     created_at: now             -->>         created_at: now.addYears(-8)
      created_by: Reading Wikipedia           created_by: Data Entry # 123             created_by: parent
 
# But how#
Data is entered using object->relation->subject
These relations are stores in the database, and can be queried, for example:
    
    #to get potential 'categories' run this query
    SELECT COUNT(*) FROM OGraphVertex WHERE in.name = 'is_a' AND NOT EXIST (SELECT 1 WHERE out.name = 'is_a' AND out.in.name = 'category') ORDER BY COUNT(*);

All entries include a limited set of meta_data, which are attributes shared by all related entities (eg. access_count, created_at, created_by, relation_weight).

As much data as possible is saved, even accessing data modifies and adds to it, therefore the same query done seconds apart could yield different results.

#project board#
https://trello.com/board/a-n-t/505e5311349fc8d53ecdf5dd

#dependencies#
https://github.com/gabipetrovay/node-orientdb