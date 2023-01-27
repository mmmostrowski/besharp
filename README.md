# BeSharp ( version 0.1.0 )

##   Object-Oriented Programming Framework for Bash 4.4+

---

Intention of this framework is to bring an object-oriented programming paradigm to the Bash language.

---
**DISCLAIMER**

**Experimental Research & Development project!**

**No backward compatibility is guaranteed!**

**Use it at your own risk!**

---
### Reasoning:

There are many mature object-oriented programming languages on the market. 
If an OOP language is needed, Bash and the BeSharp Framework may **not** be the best choice in comparison to languages like Java or Python.

Bash code is typically used for small procedural scripts. 

However, sometimes Bash scripts can become larger as new requirements arise. 
It is not always clear when it is appropriate to abandon the growth of Bash scripts and rewrite them in a modern language from scratch.

Sometimes, introducing a modern programming language(s) to workstations, along with all necessary dependencies, can be a challenging task. 
Bash is often used in this context because it is available on many Unix workstations out of the box.

What if we could write `apt-get install`-related logic in an OOP manner? <br>
What if Bash supported OOP techniques from the beginning? <br>
Would shell scripts have survived their growth?

BeSharp Framework is trying to answer for these questions.  

---
### Quick start

If you have Docker available on your workstation, please run the demo showcase app:
```shell
docker run -it --rm mmmostrowski/besharp-mvc-hello-world
```
:point_right: Visit the [demo app project page](https://github.com/mmmostrowski/besharp-mvc-hello-world) for further instructions :point_left:

---
### Features list:
  - classes, objects, fields, methods, semi-static classes,
  - interfaces, inheritance, abstract methods, abstract classes,
  - $this, object pointers mechanics, oop-like syntax,
  - returning values from methods,
  - parent methods calling,
  - setters & getters overriding, 
  - objects cloning,
  - looping && iterators,
  - built-in dependency injection, automatic *Factory classes,
  - system of collections:
    - vectors,
    - lists,
    - maps,
    - sets,
    - queues, 
    - stacks,
    - priority queues & pairing heaps,
  - compiler and runtime for *.be.sh files, 
  - different app linking and building strategies,
  - ability for plugins.
  
---
### Example code

Below is an example code of a primitive CLI arguments parsing mechanism. 
The `Arguments` class might be an OOP replacement for the Bash `getopt` command. 

```shell
#!/usr/bin/env bash

@class AppEntrypoint @implements Entrypoint

  function AppEntrypoint.main()
  {
      @let args = $this.makeArguments "${@}"

      if @true $args.get isAskingForHelp; then
          echo 'An example Hello-World App for the BeSharp Framework.' >&2
          echo '' >&2
          echo 'Usage:' >&2
          $args.printUsage >&2
          return 0
      fi

      @let greetingText = $this.greetingText $args

      if @true $args.get isLoud; then
          echo "$( @fmt bold )${greetingText}$( @fmt reset )"
      else
          echo "${greetingText}"
      fi
  }

  function AppEntrypoint.greetingText() {
      local args="${1}"

      @returning "$( @ $args.get greeting ) $( @ $args.get subject )$( @ $args.get suffix )"
  }

  function AppEntrypoint.makeArguments()
  {
      @let arguments = @new Arguments "${@}"

      $arguments.add greeting \
          '--greeting' '-g' \
          'The way you want to greet. Default greeting is: ' 'Hello'

      $arguments.add subject \
          '--subject' '-s' \
          'The subject you want to greet. Default subject is: ' 'World'

      $arguments.add suffix \
          '--suffix' '-u' \
          'The string being placed at the end. Default is: '  '.'

      $arguments.addFlag isLoud \
          '--loud' '-l' \
          'Makes bold output.'  'false'

      $arguments.addFlag isAskingForHelp \
          '--help' '-h' \
          'Show help.' 'false'

      $arguments.process

      @returning $arguments
  }

@classdone


@class Arguments

  @var Map arguments
  @var Vector inputArgs
  @var Map inputValues
  @var Vector argsInOrder

  function Arguments()
  {
      @let $this.inputArgs = @vectors.make "${@}"
      @let $this.inputValues = @maps.make
      @let $this.arguments = @maps.make
      @let $this.argsInOrder = @vectors.make
  }

  function Arguments.add()
  {
      $this.createArgument false "${@}"
 }

  function Arguments.addFlag()
  {
      $this.createArgument true "${@}"
  }

  function Arguments.process()
  {
      $this.initDefaultValues

      @let inputValues = $this.inputValues

      local nextItemIsValue=false
      while @iterate @of $this.inputArgs @in arg; do
          if $nextItemIsValue; then
              $inputValues.set "${key}" "${arg}"
              nextItemIsValue=false
              continue
          fi

          @let arg = $this.findArgument "${arg}"
          @let key = $arg.key

          if @true $arg.isFlag; then
              $inputValues.set "${key}" true
          else
              nextItemIsValue=true
          fi
      done

      if $nextItemIsValue; then
          local argText
          argText="$( @ $arg.longName ) ($( @ $arg.shortName ))"
          besharp.error "The value is missing for ${argText} argument!"
      fi
  }

  function Arguments.get()
  {
      local key="${1}"

      @let inputValues = $this.inputValues
      @returning @of $inputValues.get "${key}"
  }

  function Arguments.printUsage()
  {
      local margin=19

      @let arguments = $this.arguments
      while @iterate @of $this.argsInOrder @in arg; do
          local paddingText=''
          local totalString="$( @ $arg.longName )$( @ $arg.shortName )"
          local paddingSize=$(( margin - ${#totalString} ))
          while (( --paddingSize >= 0 )); do
              paddingText+=' '
          done

          echo -n "  "
          if @true $arg.isFlag; then
              echo -n "$(@ $arg.shortName), $(@ $arg.longName)             ${paddingText} - "
              @echo $arg.description
          else
              echo -n "$(@ $arg.shortName) value, $(@ $arg.longName) value ${paddingText} - "
              echo "$(@ $arg.description)$(@fmt bold)$(@ $arg.defaultValue)$(@fmt reset)"
          fi
      done
  }

  function Arguments.createArgument()
  {
      @let arg = @new Argument

      $arg.isFlag = "${1}"
      $arg.key = "${2}"
      $arg.longName = "${3}"
      $arg.shortName = "${4}"
      $arg.description = "${5}"
      $arg.defaultValue = "${6}"

      @let map = $this.arguments
      $map.set "${2}" $arg

      @let vector = $this.argsInOrder
      $vector.add $arg
  }

  function Arguments.findArgument()
  {
      local name="${1}"

      @returning ""
      while @iterate @of $this.arguments @in argument; do
          if @returned @of $argument.longName == "${name}" \
              || @returned @of $argument.shortName == "${name}"; then

              @let key = $argument.key
              @let arguments = $this.arguments

              @returning @of $arguments.get "${key}"
              return
          fi
      done

      besharp.error "Invalid argument: ${arg}!"
  }

  function Arguments.initDefaultValues()
  {
      @let inputValues = $this.inputValues

      while @iterate @of $this.arguments @in argument; do
          @let key = $argument.key
          @let defaultValue = $argument.defaultValue

          $inputValues.set "${key}" "${defaultValue}"
      done
  }

@classdone


@class Argument

  @var key
  @var longName
  @var shortName
  @var description
  @var defaultValue
  @var isFlag

@classdone
```

Example usage ( _see below how to run_ ): 
```
develop --greeting "How are you" -s "programmer" --suffix '?'
```
Target compiled executable script for this example can be found [here](docs/besharp-arguments-example.sh).

---
### How to run

The framework is mainly composed of two components:  
 - **Compiler** - transforms BeSharp OOP code into *.be.sh distribution files,
 - **Runtime** - executes BeSharp *.be.sh files on a native Bash 4.4+.

These components can be combined into a single shell script or separated, depending on the chosen building preset.

#### Building Presets

There are four default building presets available for your app:
  - `single-script` (default) 
    - compiles your app code and BeSharp Runtime code into a single *.sh script,
    - the client workstation is not required to have the BeSharp Runtime installed, 
    - all code is loaded at once during start,
  - `single-script-noruntime` 
    - compiles your app code into a single *.sh, but without including the BeSharp Runtime,
    - the client workstation is required to have the BeSharp Runtime installed,
    - all code is loaded at once during start,
  - `multi-file` 
    - compiles your app into a series of *.be.sh files, including the BeSharp Runtime *.be.sh file,
    - the client workstation is not required to have the BeSharp Runtime installed, 
    - code is loaded dynamically, "when needed" by the app runtime,
  - `multi-file-noruntime` 
    - compiles your app into a series of *.be.sh files, 
    - but without including the BeSharp Runtime *.be.sh file, 
    - the client workstation is required to have the BeSharp Runtime installed, 
    - code is loaded dynamically, "when needed" by the app runtime.
    
_Note: You can choose the default preset in the `default.preset` file._

#### Execution 
 
Your app source code is in the `/app/src/` folder.
Target distribution code can be found in the `/app/dist/<preset>/` folders.

There are two modes available for execution:
  - `develop` - provides a better experience for development:
     - Bash shows errors in the direct source files,
     - more code verifications occur during code runtime,
     - but it works slower.
  - `production` -  executes final production code:
     - works faster due to compiler code optimizations being applied,
     - some code verifications are off,
     - but Bash shows errors in the target distribution files, making debugging harder.  

The BeSharp framework provides three basic commands:
  - `run` 
     - compiles source code and executes the produced distribution code in *production* mode,    
  - `develop` 
     - compiles source code and executes it in *development* mode,
  - `build` 
     - compiles source code into distribution code for all presets without executing it.


### Develop locally

#### 1. When Docker Engine is available

Please open BeSharp terminal:
- **on Linux / MacOs** - please run `./besharp` from the project folder,
 - **on Windows** - please run `besharp.bat` from the project folder.

---
To run app in a **production** mode:

```
run [ your app params ... ]

# to run given preset
run --preset <preset> [ your app params ... ]

# to force compilation of all files, instead of compiling only changed files
run --compile-all [ your app params ... ]
```

---
To run app in a **developer** mode:  

```shell
develop [ params ... ]

# to run given preset
develop --preset <preset> [ your app params ... ]

# to force compilation of all files, instead of compiling only changed files
develop --compile-all [ your app params ... ]
```

To build the project into `dist/` folders, **without running it**:

```shell
build

# to build given preset
build --preset <preset>

# to force compilation of all files, instead of compiling only changed files
build --compile-all
```

To run the project on the native Bash on Linux/Unix host machine, instead of BeSharp docker terminal:
```shell
./besharp build --preset <preset> \
   && ./app/dist/<preset>/app  [ your app params ... ]
```

#### 2. When NO Docker Engine is available

BeSharp Framework has been developed and tested on **Ubuntu 20.04**. 
If you have no Docker installed, you might want to try to execute BeSharp Framework directly on the host machine. See below examples:
```shell
./bin/run [ your app params ... ]

./bin/develop [ your app params ... ]

./bin/build --compile-all 
```

---
### What next? 

Ideas:
  - documentation and tutorials,
  - working on performance,
  - writing automated tests ( unit tests, performance tests, ... ),
  - more syntax sugar ( e.x. to decrease amount of `@let` instructions in the code )
  - testing and adapting architecture to various business scenarios,
  - more code validations and better communication with the user, 
  - more language features: constants, enums, namespaces, public/private/protected visibility modifiers, "@final" keyword, etc.
  - better debugger & development tooling,
  - working on bigger OOP framework code base ( e.x. utils for strings, dates & float numbers, enhance collections, support for parallel programming, etc. )
  - providing a packaging system allowing to publish and share code easily between developers,  
  - support for older Bash 4.3- versions,
  - considering Bash 3+ support,
  - more ...

---

BeSharp by Maciej Ostrowski (c) 2023
