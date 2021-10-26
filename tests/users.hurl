GET http://localhost:3000/users

HTTP/1.1 200

[Asserts]
duration < 1000
jsonpath "$.[0].id" == 1
