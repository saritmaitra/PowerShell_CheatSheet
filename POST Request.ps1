# Invoke_WebRequest is the cmdlet to interface with RESTful web API

$URL = "https://api.github.com" # API URL
$Endpoint = "/gists" # endpoint we want to talk to
# Gist is an online sctatchpad for code, note and pther data using git version control

$URLAnon = "$URL$Endpoint"

# we need to create the gist by making Powershell Hash Table which is thye representation of what the API end point is looking for
# Hash Tables are like arrays but we access their values through key intead of an index.
# $HTable = @{key='value}
# HTable.key will give us the value

$JSON = ConvertTo-Json @{
          description = "the description for this gist";
          public =  $true;
          files = @{
            "file1.txt" = @{
              content = "String file contents"
            }
          }
        }

$JSON # we will see it has converted the Hash Table to Json structure

# now we can take this json and send it to their API

$gist = Invoke-RestMethod -Method Post -Uri $URLAnon -Body $JSON

# Not every API will use Json; so we need to make sure to check their documentation

$Token = "?access_token=92a3af3c5ebc6afbfc0018db3215a490058b8537"
$URLSecure = "$URL$Endpoint$Token"

$gist = Invoke-RestMethod -Method Post -Uri $URLSecure -Body $JSON

$URLEdit = "$URL$Endpoint/$($gist.id)$Token"

$JSON2 = ConvertTo-Json @{
          description = "Potato";
          public =  $true;
          files = @{
            "file1.txt" = @{
              content = "I'm Hungry"
            }
          }
        }

$gist = Invoke-RestMethod -Method Post -Uri $URLEdit -Body $JSON2
