


go mod init module  : creates go.mod file which desribles name of the module and version of go.


module -> package -> files



# package 
package is a collection of one or more go files

if code is spread acrros multiple go files in same pacakge

use this command # go run main.go helper.go  # where a funcion in helper.go is called in main.go

or use #go run . 


when you have multiple packages, create folder for each package and put all related files in the folder
and then use "import modulename/package"

and use package.func()

eg:-  
import booking-app/helper

 helper.validateUsers()


## export a function across all packages
first letter of the funcaion name to Capital letter

note: fmt.Printf  # see P is capital, which means exportes

eg:- 

file: main.go:
-------------
package main
main()
helper.ValidateUserInput()

file: helper/helper.go 
----------------------
package helper
ValidateUserInput(){}


# maps

var userData = make(map[key]value)

eg:
var userData = map


## list/slice of maps

var bookings = make([]map[string]string, 0)  # initial size of list is requiered here

Note : list/maps cannot have mixed data types

# structs for mixed data types
type userData struct {
  fristNAme string
  age  int
  isuserinterested bool
}

# type
type creates custom new data type

# list of structs

var bookings = make([]userData, 0)

# conucrrency

a function that sleeps for 10 seconds
 with time.Sleep(18* time.Second)

using go routines
#Goroutine is a 'Green thread'
  - cheapar to create and lightweight 
  - abstraction of acutal thread
  - less memory
  - many benefits compared to OS threads

go funcname #while caling the method

eg:- go print_and_sendemial()

## make main thread wait for sub-thread 
import sync
var wg = sync.WaitGroup{}

wg.Add(1)
go print_and_sendemial()

at the end of main thread
wg.Wait()  # dont't exit the main thread until sub thread is finished


inside the function print_and_sendemial()
wg.Done()

# vars
## all are same
var name int =50

or

var name =50

or

name := 50 


Sprintf : prints string to a variable


func printFirstNames(x int)int{}
# int after the function indicates return type
func printFirstNames(bookings []string)[]string{}

# mutliple return types
func printFirstNames(bookings []string)i([]string, bool, int) {}
 # call using a, b, c = printFirstNames(bookings)




