# Easy IC : open-source, cross-platform framework for developing digital ASIC and FPGA designs

## NOTE: this project has just been started. Hence, the description below is what will come in the future, but none of the features have been implemented yet.

ECIC is pronounced '`Easy IC`' and is an open-source, cross-platform framework for developing digital ASIC and FPGA designs. It enables you to quickly start a new IC project that is independent of both IC tool vendors and technology (FPGA/ASIC). ECIC creates a suitable project folder/file structure and provides a user friendly flow for configuring the project, fast compilation of RTL files etc.. It also provides generators for generating eg. new RTL files, libraries and testbenches for both VHDL, SystemVerilog and UVM.

One of the mantras for ECIC is `Convention Over Configuration` (inspired by the [https://rubyonrails.org/](RubyOnRails) web framework), which ensures a consistent structure across all projects using this framework - and a minimum of required configuration.

**The main highlights are:**

  * Free and open-source
  * Cross-platform (Windows, Linux)
  * Scaffolding of projects and sub components
  * IC tool vendor independent flow
  * IC technology independent flow
  * Convention over configuration
  * Fast, parallel compilation of RTL files
  * Automatic GNU Make dependency graph generation for VHDL files
  * Easily extendable with custom features

## Installation

To install the framework, simply use the `gem` command:

    $ gem install ecic

If the `gem` command is not available on your computer, you can get it through the RubyGems package available at [rubygems.org](https://rubygems.org).

## Usage

The `ecic new` command creates a new ECIC project with a default directory structure and configuration at the path you specify. To create a new project in a folder called `./my_project`, run:

    $ ecic new my_project

If you already have an existing project and you want the project to use the ECIC framework, please follow the steps described in the 'Migrating an existing project to use ECIC' section below.

### Create new RTL library

Each RTL file in your project must belong to a given VHDL/Verilog library. When creating or adding RTL files to you project, a library can be created on the fly, but you can also create libraries manually using the `ecic generate library` command.

To create a library called `my_lib`, enter the project folder and run the `generate library` command, eg.:

    $ cd my_project
    $ ecic generate library my_lib

This will create a folder called `my_lib` in the `./src/design` folder and add the library to the project (by adding it to the `./src/config/libraries.rb` file).

You can create multiple libraries with one command by specifying a list of libraries, eg.:

    $ ecic generate library my_lib1 my_lib2

<!--
By default, the `ecic generate library` command will also create an RTL design (VHDL component + entity + architecture or Verilog module) with the same name as the library. 
The RTL design is automatically added to the library by adding it to the `sources.rb` file, which will be created at the root of each library folder.
-->
A `sources.rb` file will be created at the root of each library folder, which defines the RTL files that must be associated with the given library.

To see the full list of options for the `ecic generate library` command, run `ecic generate help library`.

### Create new RTL file

Creating a **new** RTL design can be done with the `ecic generate design` command. For VHDL designs, this command will generate both the component, entity and architecture and for SystemVerilog it will create a module. If you already have existing RTL design files you wish to add to the project, you should use the `ecic add design` command instead, see the 'Add existing RTL files' section.

The type of RTL design (VHDL or Verilog) to create is controlled by a `--type=vhdl|verilog` option and defaults to the value defined by the `config.generator.library.type.default` setting in the `./src/config/ecic.rb` configuratinon file.

To see the full list of options for the `ecic generate design` command, run `ecic generate help design`.

#### Create new VHDL design(s)

To create a new VHDL design called `my_design1` and associate it with a library called `my_lib`, run:

    $ ecic generate design --type=vhdl my_lib my_design1

When creating a new VHDL design, you will be given the option to also create and include a `types and constants` package definition file.

The following VHDL files will be created (relative to the project root folder):

    ./src/design/my_lib/my_design1-pkg-comp.vhd    # Component definition
    ./src/design/my_lib/my_design1-ent.vhd         # Entity definition
    ./src/design/my_lib/my_design1-arc-rtl.vhd     # RTL architecture
    ./src/design/my_lib/my_design1-pkg-types.vhd   # Types and constants definition package (optional)                                                     

Placing each component, entity and architecture in separate files allows a projects to be recompiled very fast when only a few files have been modified, since eg. an update that is isolated to a single RTL architecture only requires that one file to be recompiled. Splitting the entity and architecture into separate files also allows you to have multiple architectures for the save entity and choose between the architecture files at compile time without having to use `VHDL configuration` constructs.

Should you wish to combine eg. the entity and architecture files into one file, you can configure `ECIC` to do this by default by setting `config.generator.design.vhdl.combine` option in `./src/config/ecic.rb`:

    config.generator.design.vhdl.combine = 'entity + architecture'

If you specify a library that does not exist, you will be asked to confirm the creation of the new library.

You can create multiple designs at the same time, and designs can be placed in subfolders within a library. For example, to create a new VHDL design called `my_design2` at the root of a `my_lib` library and create another VHDL design called `my_design3` in a subfolder called `my_subblock`, run:

    $ ecic generate design --type=vhdl --types-package my_lib my_design2 my_subblock/my_design3

This will create the following VHDL files (relative to the project root folder):

    ./src/design/my_lib/my_design2-comp.pkg.vhd                # Component definition
    ./src/design/my_lib/my_design2-ent.vhd                     # Entity definition
    ./src/design/my_lib/my_design2-rtl_arc.vhd                 # RTL architecture
    ./src/design/my_lib/my_design2-pkg-types.vhd               # Types and constants definition package (optional)                                                     
    ./src/design/my_lib/my_subblock/my_design3-comp-pkg.vhd    # Component definition
    ./src/design/my_lib/my_subblock/my_design3-ent.vhd         # Entity definition
    ./src/design/my_lib/my_subblock/my_design3-rtl_arc.vhd     # RTL architecture
    ./src/design/my_lib/my_subblock/my_design3-pkg-types.vhd   # Types and constants definition package (optional)                                                     

In this example the `--types-package` option is used to automatically include the `*-pkg-types.vhd` files without prompting the user with the option.
 
All generated VHDL files will be added to the `sources.rb` file in the given library.

#### Create new SystemVerilog file

The procedure for creating SystemVerilog files is the same as for generating VHDL files, except that the `--type` option must be set to `sv`.

For example, to create one SystemVerilog module called `my_design1` and place it with a library called `my_lib`, run:

    $ ecic generate design --type=sv my_lib my_design1

This will create the following SystemVerilog files (relative to the project root folder):

    ./src/design/my_lib/my_blk/my_design1.sv    # SystemVerilog module

All generated SystemVerilog files will be added to the `sources.rb` file in the given library.

## Migrating an existing project to use ECIC

If you already have an existing project and you want the project to use the ECIC framework, simply specify the path to that project folder (after making sure you have a backup, of course) eg.:

    ecic new ~/my_existing_project

If the folder contains files that will normally be overwritten by the framework, you will be asked whether to overwrite them. If you want to keep any conflicting files, then choose `n` (no, do not overwrite) for each conflicting file. You can then move or rename the original, conflicting files and run the `ecic new PATH` command again.

### Add existing RTL files

To add an existing RTL file to the project, go to the project folder and use the `ecic add design` commmand. This will add all the listed files to the given design library. If the library does not already exist, you will be asked to confirm the creation of it.

For example, to add two existing files 

    $ ecic add design LIBRARY FILE <FILE>...

## Compiling and elaborating RTL files

The project is compiled and elaborated with the `ecic compile [SCOPE]` command. The `SCOPE` option is optional and allows you to compile and elaborate different set of RTL files, eg. one set of files for an FPGA, another set of files for ASIC RTL simulations and a third set of files for ASIC gate-level simulations.

To compile and elaborate your project, simply run:

    $ ecic compile [SCOPE]

SystemVerilog files will be compiled in the order they are listed in the sources.rb files and they will be compiled before any VHDL files.
before any 


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install the ECIC framework onto your local machine, run `bundle exec rake install`.
<!--
 To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-->
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ic-factory/ecic.
