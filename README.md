# BatchModul
Subroutines for BatchScripts WORKS FOR ME ON WINDOWS 10

I hope some moduls are usefull for someone.
Attention with special chars like !"§$%&/()= if you have to process this it can be very unstable
Make sure to double quote every parameter to avoid problems with spaces and things.

# HOW TO USE
  call a modul with it's needed parameters
  RESERVED VARS: return,errorlevel
  every modul gives an errorlevel.  0 is good 0< could be a error or information see errorlevel list
  ervey modul overwrits "return" var to blank or to it's return value
  in the sourcecode of the moduls you can find witch parameters are needet
  no big documentations needet i think so, if it is not self explaining to you, you should not use the moduls, it could be not safe and destroy or overwrite some files.
  
  



Some moduls are barely tested in reliability with unexpected input.


#QUICK VIEW
  file
    - cntLine "file"
    - cntLineNoSkip "file"
    - readLine "file" "lineNumber"
    - readLineNoSkip "file" "lineNumber"
  str
    - cntToken "string" "delimiter"
    - getToken "string" "delimiter" "TokenNumber"
    - len "string"
    
    
#ERRORLEVEL

  	1	PARAMETER MISSING OR WRONG FORMAT 
	2	FILE NOT FOUND OR NO ACCESS
	3	Path NOT FOUND OR NO ACCESS
	4	COULD NOT ASSIGN INTEGER, MISSING OR OVERFLOW
	5	COULD NOT ASSIGN STRING, MISSING OR OVERFLOW
	6 	LIST OUT OF RANGE, OR OVERFLOW
	7 -
	8 -
	9 -
	10 -
