# DOCUMENTATION
## General
I hope some moduls are usefull for someone.  
##### Attention with special chars like !"§$%&/()= if you have to process this it can be very unstable  
##### Make sure to double quote every parameter to avoid problems with spaces and things.  

# MODUL QUICK INFO
  ## file
  
| Modul Name |-Parameter-|Description|RETURN|ERRORLEVEL'S
|--|--|--|--|--|
|cntLines  |"file"|(SLOW)Count lines in a text File *skips empty lines|(int)return|-|
|cntLinesNoSkip|"file"|(FAST)Count lines in a text File *empty lines will be recognized|(INT)return|-|
|readLine|"file" "lineNumber"|(FAST)read a line in a file. Index Base 1 *skips empty lines|(STR)return|-|
|readLineNoSkip|"file" "lineNumber"|(SLOW)read a line in a file. Index Base 1 *empty lines will be recognized|(STR)return|-|
|isFile|"file"|Check if a path leads to a file|(bool)return|-|

  ## str
| Modul Name|-Parameter-|Description|RETURN|ERRORLEVEL'S|
|--|--|--|--|--|
|cntToken|"string" "delimiterChar"|Count tokens in a CSV string|(INT)return|-|
|getToken|"string" "delimiterChar" "TokenNumber"|Get a specific token from a CSV String|(STR)return|-|
|len|"string"|returns the length of a string|(INT)return|-| 

## tui
| Modul Name|-Parameter-|Description|RETURN|ERRORLEVEL'S|
|--|--|--|--|--|
|select|"file" "itemsPerPage" "InfoString" "preselectIndex" |Let's a user select a line from a file and returns the selection. Can be used as a menu|(str)value,(int)index,(NUL)return|-|
# ERRORLEVEL
| ERRLVL| DESCRIPTION  |
|--|--|
|1 |PARAMETER MISSING OR WRONG FORMAT|
|1|PARAMETER MISSING OR WRONG FORMAT |
|2| FILE NOT FOUND OR NO ACCESS|
|3| Path NOT FOUND OR NO ACCESS
|4| COULD NOT ASSIGN INTEGER, MISSING OR OVERFLOW
|5| COULD NOT ASSIGN STRING, MISSING OR OVERFLOW
|6| LIST OUT OF RANGE, OR OVERFLOW
|7| -
|8| -
|9| -
