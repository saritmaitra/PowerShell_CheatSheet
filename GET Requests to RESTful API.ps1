# Invoke-RestMethod

## 1. Endpoint (Location of API data which is 'RestMethod' here)
## 2. Method ('Get' method - collect information from API; Method describes how we want to interact with an endpoint.
# how they are used will vary across different APIs) 
## 3. Content Type (Content in Modern RESTful APIs usually delivered in json format)

# EXAMPLE: https://www.reddit.com/
# https://www.reddit.com/.json

$data = Invoke-RestMethod -Method Get -Uri 'https://www.reddit.com/.json

$data # look into the variable

$data | Get-Member # json data is taken as PowerShell object

$data.data

$data.data.children

$data.data.children[0]

$data.data.children[0].data

$data.data.children[1].data
  
