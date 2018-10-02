Here is a list of tools and features that we hope will be available in the future. Contributions and suggestions are most welcome.

### Tools:

  * Plugin for various editors that make is easy to eg. create new RTL libraries and designs.
  * Tool to include external libraries from 3ed parties.
  * Tool to import a XILINX Vivado project file.

### Features:

  * TBD
  
###Observations:

GNU Make commands are not suited as a multiple-level command line. It does not have built-in argument checking for target, in the sence that if you need to provide an argument to the a Make command and you misspell the argument, no built-in warnings will be given.

Example:

    > make some_target some_option=whatever
    > make some_target something_wrong=whatever
    > make some_target some_option=whatever
  

#Requirements
  * library names must be converted to snake_case before creating a new library.