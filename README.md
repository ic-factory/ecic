# Easy IC

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

and the install the dependencies for your new project using Bundler:

    $ cd ./my_project
    $ bundle install

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

Creating a **new** RTL design can be done with the `ecic generate design` command. For VHDL designs, this command will generate both the component, entity and architecture and for SystemVerilog it will create a module. If you already have existing RTL design files you wish to add to the project, you should use the `ecic add design` command instead, see the `Add existing RTL files` section.

The type of RTL design (VHDL or Verilog) to create is controlled by a `--type=vhdl|sv` option and defaults to the value defined by the `config.generator.library.type.default` setting in the `./src/config/ecic.rb` configuratinon file.

The `ecic generate design` command can be called from any directory within your project. To see the full list of options for the `ecic generate design` command, run `ecic generate help design`.

#### Create new VHDL design(s)

To create a new VHDL design called `my_design1` and associate it with a library called `my_lib`, run:

    $ ecic generate design --type=vhdl --lib=my_lib my_design1

If you specify a library that does not exist, you will be asked to confirm the creation of the new library.

When creating a new VHDL design, you will be given the option to also create and include a `types and constants` package definition file.

The following VHDL files will be created (relative to the project root folder):

    ./src/design/my_lib/my_design1-pkg_types.vhd   # Types and constants definition package (optional)                                                     
    ./src/design/my_lib/my_design1-pkg_comp.vhd    # Component definition
    ./src/design/my_lib/my_design1-ent.vhd         # Entity definition
    ./src/design/my_lib/my_design1-arc_rtl.vhd     # RTL architecture

Placing each component, entity and architecture in separate files allows a projects to be recompiled very fast when only a few files have been modified, since eg. an update that is isolated to a single RTL architecture only requires that one file to be recompiled. Splitting the entity and architecture into separate files also allows you to have multiple architectures for the save entity and choose between the architecture files at compile time without having to use `VHDL configuration` constructs.

Should you still wish to combine eg. the entity and architecture files into one file, you can configure `ECIC` to do this by default by setting the `config.generator.design.vhdl.combine` option in `./src/config/ecic.rb`, eg.:

    config.generator.design.vhdl.combine = 'entity + architecture'

This would result in a file with a `-ent-arc_rtl.vhd` extention for the file containing both the entity and architecture.

##### Create multiple VHDL designs for the same library

You can create multiple designs at the same time, and designs can be placed in subfolders within a library. For example, to create a new VHDL design called `my_design2` at the root of a library called `my_lib` and create another VHDL design called `my_design3` in a subfolder called `my_subblock`, run:

    $ ecic generate design --type=vhdl --types-package --lib=my_lib my_design2 my_subblock/my_design3

This will create the following VHDL files (relative to the project root folder):

    ./src/design/my_lib/my_design2-pkg_types.vhd               # Types and constants definition package (optional)                                                     
    ./src/design/my_lib/my_design2-pkg_comp.vhd                # Component definition
    ./src/design/my_lib/my_design2-ent.vhd                     # Entity definition
    ./src/design/my_lib/my_design2-arc_rtl.vhd                 # RTL architecture
    ./src/design/my_lib/my_subblock/my_design3-pkg_types.vhd   # Types and constants definition package (optional)                                                     
    ./src/design/my_lib/my_subblock/my_design3-pkg_comp.vhd    # Component definition
    ./src/design/my_lib/my_subblock/my_design3-ent.vhd         # Entity definition
    ./src/design/my_lib/my_subblock/my_design3-arc_rtl.vhd     # RTL architecture

In this example the `--types-package` option is used to automatically include the `*-pkg-types.vhd` files without prompting the user with the option.
 
All generated VHDL files will be added to the `sources.rb` file in the given library.

#### Create new SystemVerilog file(s)

The procedure for creating SystemVerilog files is the same as for generating VHDL files, except that the `--type` option must be set to `sv`.

For example, to create two SystemVerilog modules called `my_design1` and `my_design2` and place them in separate subfolders within a library called `my_lib`, run:

    $ ecic generate design --type=sv --lib=my_lib my_design1 my_design2

This will create the following SystemVerilog files (relative to the project root folder):

    ./src/design/my_lib/my_design1.sv    # SystemVerilog module
    ./src/design/my_lib/my_design2.sv    # SystemVerilog module

All generated SystemVerilog files will be added to the `sources.rb` file in the given library.

#### Omitting the --lib option

If the `ecic generate design` command is called from within a library folder (or subfolder) and the `--lib` option is omitted, the new designs will be created for the library in that folder.

Example:

    $ cd ./src/design/queue_system/arbitor
    $ ecic generate design --type=vhdl statemachine

That will generate the files as:

    ./src/design/queue_system/statemachine-*.vhd      #Path is relative to the project root folder

**Note:** Even though the current working directory in this example is `arbitor`, the generated files will be placed in the `queue_system` folder, since no hierarchy is included in the design name.

## Migrating an existing project to use ECIC

If you already have an existing project and you want the project to use the ECIC framework, simply specify the path to that project folder (after making sure you have a backup, of course) eg.:

    $ ecic new ~/my_existing_project

and the install the dependencies for your project using Bundler:

    $ cd ~/my_existing_project
    $ bundle install

If the folder contains files that will normally be overwritten by the framework, you will be asked whether to overwrite them. If you want to keep any conflicting files, then choose `n` (no, do not overwrite) for each conflicting file. You can then move or rename the original, conflicting files and run the `ecic new PATH` command again.

### Add existing RTL files

To add an existing RTL file to the project, go to the project folder and use the `ecic addfile` commmand. This will add all the listed files to your project.

You can specify the library name with the `--lib` option or rely on an implicit library name that is extracted from the full paths of the added files. In the latter case the extracted library name will be equal to the name of the directory just under `src/design` or `src/testbench`. In either case, if the library does not already exist, you will be asked to confirm the creation of it.

For example, given that:

  * you have a Unix like terminal
  * you want to eg. add all design files that have a `.vhd` or `.sv` extention
  * all design files are placed in subfolders under a `./src/design`
  * all files for a given RTL library are placed under a folder (of the same name) in the `./src/design`

... then you can use the standard Unix `find` command and leave out the `--lib` option:

    $ ecic addfile `find ./src/design -name "*.vhd"` `find ./src/design -name "*.sv"`

Although all files that belong to a given library should be placed in the folder for that library, you can specify files that are placed anywhere in your file system, but this requires using the `--lib` option. For example, to add two existing files named `./foo/bar/some_design.sv` and `../../some/path/outside/the/library/folder/kuku.vhd` to a library called `my_lib`, run:

    $ ecic addfile --lib=my_lib ./foo/bar/some_design.sv ../../some/path/outside/the/library/folder/kuku.vhd

If all your VHDL designs assume to be compiled into one library called `work`, you can just set `--lib=work`, eg.:

    $ ecic addfile --lib=work `find . -name "*.vhd"`

When adding files to the project, the file extension (eg. .vhd) is used to determine the file type. VHDL files are expected to have a .vhd or .vhdl extension and Verilog/SystemVerilog files are expected to have a .sv og .v extension. You can also specify the file type with a `type=vhdl|sv` option, eg.:

    $ ecic addfile --type=vhdl --lib=my_lib `find ./foo -name "*.*"`

## Compiling and elaborating RTL files

The project is compiled and elaborated with the `ecic compile [SCOPE]` command. The `SCOPE` option is optional and allows you to compile and elaborate different set of RTL files, eg. one set of files for an FPGA, another set of files for ASIC RTL simulations and a third set of files for ASIC gate-level simulations.

To compile and elaborate your project, simply run:

    $ ecic compile [SCOPE]

SystemVerilog files will be compiled in the order they are listed in the sources.rb files and they will be compiled before any VHDL files.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install the ECIC framework onto your local machine, run `bundle exec rake install`.
<!--
 To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
-->
## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am "Add some feature"`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

Bug reports and pull requests are most welcome on GitHub at https://github.com/ic-factory/ecic.


