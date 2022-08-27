# BeSharp ( version 0.1.0 )

##   Object-Oriented Programming Framework for Bash 4.4+

---

Intention of this framework is to bring an OOP paradigm to the Bash language.

---
**DISCLAIMER**

**Project is on the eager phase of the development process!**

**No backward compatibility guaranteed!**

**Use at your own risk!**

---
### Reasoning:

There are many mature OOP programming languages on the market.
If OOP language is needed, Bash and BeSharp Framework is probably **not** the best choice, in compare to languages like Java or Python.

Bash code is expected to be in form of small procedural scripts.

However, sometimes Bash scripts getting larger when new requirements coming up.
It's not always obvious when is the exact moment to abandon growth of Bash scripts and to rewrite them in a modern language from scratch.

Sometimes bringing a modern programming language(s) to the workstation(s), with all dependencies, is a challenging task itself.
Bash is often used for this purpose. Bash is the one which is available on many of Unix workstation, out of the box.

What if we could write `apt-get install` related logic in an OOP manner? <br>
What if Bash was supporting for OOP technics in the first place? <br>
Would shell script survived the growth?<br>

BeSharp Framework is trying to answer for these questions.  


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

### Quick start

If you have Docker available on your workstation, please run demo showcase app:
```shell
docker run -it --rm mmmostrowski/besharp-mvc-hello-world
```
Please visit [demo app project page](https://github.com/mmmostrowski/besharp-mvc-hello-world) for further instructions.   

---
### Example code
 
Below is an example code of a primitive CLI arguments parsing mechanism.
Class `Arguments` might be an OOP replacement for the Bash `getopt` command. 

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

      if @true $args.get isLoud; then
          echo "$( @fmt bold )$( @ $args.get greeting ) $( @ $args.get subject )!$( @fmt reset )"
      else
          echo "$( @ $args.get greeting ) $( @ $args.get subject )$( @ $args.get suffix )"
      fi
  }

  function AppEntrypoint.makeArguments()
  {
      @let arguments = @new Arguments "${@}"

      $arguments.addValuedOption greeting \
          '--greeting' '-g' \
          'The way you want to greet. Default greeting is: ' 'Hello'

      $arguments.addValuedOption subject \
          '--subject' '-s' \
          'The subject you want to greet. Default subject is: ' 'World'

      $arguments.addValuedOption suffix \
          '--suffix' '-u' \
          'The string being placed at the end. Default is: '  '.'

      $arguments.addFlagOption isLoud \
          '--loud' '-l' \
          'You can shout, by providing this flag.'  'false'

      $arguments.addFlagOption isAskingForHelp \
          '--help' '-h' \
          'Show help.' 'false'

      $arguments.process

      @returning $arguments
  }

@classdone


@class Arguments

  @var Vector args
  @var Map options
  @var Vector optionsInOrder
  @var Map values

  function Arguments()
  {
      @let $this.args = @vectors.make "${@}"
      @let $this.options = @maps.make
      @let $this.optionsInOrder = @vectors.make
      @let $this.values = @maps.make
  }

  function Arguments.addValuedOption()
  {
      $this.addOption true "${@}"
 }

  function Arguments.addFlagOption()
  {
      $this.addOption false "${@}"
  }

  function Arguments.process()
  {
      @let options = $this.options
      @let values = $this.values

      $this.initDefaultValues

      local nextItemIsValue=false
      while @iterate @of $this.args @in arg; do
          if $nextItemIsValue; then
              $values.set "${key}" "${arg}"
              nextItemIsValue=false
              continue
          fi

          @let key = $this.findOptionForArg "${arg}"
          @let option = $options.get "${key}"

          if @true $option.isValued; then
              nextItemIsValue=true
          else
              $values.set "${key}" true
          fi
      done

      if $nextItemIsValue; then
          local argText
          argText="$( @ $option.longOption ) ($( @ $option.shortOption ))"
          besharp.error "The value is missing for ${argText} argument!"
      fi
  }

  function Arguments.get()
  {
      local key="${1}"

      @let values = $this.values
      @returning @of $values.get "${key}"
  }

  function Arguments.printUsage()
  {
      local margin=19

      @let options = $this.options
      while @iterate @of $this.optionsInOrder @in optionKey; do
          @let opt = $options.get "${optionKey}"
          local paddingText=''
          local totalString="$( @ $opt.longOption )$( @ $opt.shortOption )"
          local paddingSize=$(( margin - ${#totalString} ))
          while (( --paddingSize >= 0 )); do
              paddingText+=' '
          done

          echo -n "  "
          if @true $opt.isValued; then
              echo -n "$(@ $opt.shortOption) value, $(@ $opt.longOption) value ${paddingText} - "
              echo "$(@ $opt.description)$(@fmt bold)$(@ $opt.defaultValue)$(@fmt reset)"
          else
              echo -n "$(@ $opt.shortOption), $(@ $opt.longOption)              ${paddingText} - "
              @echo $opt.description
          fi
      done
  }

  function Arguments.addOption()
  {
      @let option = @new ArgumentOption

      $option.isValued = "${1}"
      $option.key = "${2}"
      $option.longOption = "${3}"
      $option.shortOption = "${4}"
      $option.description = "${5}"
      $option.defaultValue = "${6}"

      @let options = $this.options
      $options.set "${2}" $option

      @let optionsInOrder = $this.optionsInOrder
      $optionsInOrder.add "${2}"
  }

  function Arguments.findOptionForArg()
  {
      local arg="${1}"

      @returning ""
      while @iterate @of $this.options @in option; do
          @let key = $option.key
          @let longOption = $option.longOption
          @let shortOption = $option.shortOption

          if [[ "${arg}" == "${shortOption}" ]] || [[ "${arg}" == "${longOption}" ]]; then
              @returning "${key}"
              return
          fi
      done

      besharp.error "Invalid argument: ${arg}!"
  }

  function Arguments.initDefaultValues()
  {
      @let options = $this.options
      @let values = $this.values

      while @iterate $options @in option; do
          @let key = $option.key
          @let defaultValue = $option.defaultValue

          $values.set "${key}" "${defaultValue}"
      done
  }

@classdone


@class ArgumentOption

  @var key
  @var longOption
  @var shortOption
  @var description
  @var defaultValue
  @var isValued

@classdone
```

Example usage ( _see below how to run_ ): 
```
develop --greeting "How are you" -s "programmer" --suffix '?'
```

---
### How to run

Framework is mainly built of two components:  
 - **Compiler** - transforms BeSharp OOP code into *.be.sh distribution files,
 - **Runtime** - executes BeSharp *.be.sh files on a native Bash 4.4+.
 
These components might be combined into single shell script, or be separated. 
It depends on the given building preset. 

#### building presets

There are four default building presets available for your app:
  - `single-script` (default) 
    - compiles your app code and BeSharp Runtime code into single *.sh script, 
    - client workstation is not required to have BeSharp Runtime installed,
    - all code is loaded at once during start,
  - `single-script-noruntime` 
    - compiles your app code into single *.sh, but without including Besharp Runtime in it,
    - client workstation is required to have BeSharp Runtime installed,
    - all code is loaded at once during start,
  - `multi-file` 
    - compiles your app into series of *.be.sh files, including BeSharp Runtime *.be.sh file, 
    - client workstation is not required to have BeSharp Runtime installed,
    - code is loaded dynamically, "when needed" by the app runtime,
  - `multi-file-noruntime` 
    - compiles your app into series of *.be.sh files, but without including Besharp Runtime *.be.sh file,
    - client workstation is required to have BeSharp Runtime installed,
    - code is loaded dynamically, "when needed" by the app runtime,
    
_Note: You can choose default preset in the `default.preset` file._

#### development 
 
Your app source code is in the `/app/src/` folder.
Target distribution code can be found in the `/app/dist/<preset>/` folders.

There are two modes available for the development:
  - `develop` - gives better experience for the development:
     - Bash is showing errors in our direct source files,
     - more code verifications occurring during code runtime,
     - works slower.
  - `production` - executes final production code:
     - works faster due to compiler code optimizations being applied,
     - some code verifications are off,
     - Bash is showing errors in target distribution files, which makes debugging harder.  
     
BeSharp framework provides three basic commands to establish a development workflow:
  - `run` 
     - compiles source code and executes produced distribution code in the *production* mode,    
  - `develop` 
     - compiles source code and executes it in the *development* mode,
  - `build` 
     - compiles source code into distribution code, for all presets, without executing it.


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
   &&  ./app/dist/<preset>/app  [ your app params ... ]
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
### Roadmap

What is planned next?
  - documentation and tutorials,
  - working on performance,
  - writing automated tests ( unit tests, performance tests, ... ),
  - more syntax sugar ( e.x. to decrease amount of `@let` instructions in the code )
  - testing and adapting architecture to various business scenarios,
  - support for older Bash 4.3- versions,
  - more code validations and better communication with the user, 
  - more language features: constants, enums, namespaces, public/private/protected visibility modifiers, "@final" keyword, etc.
  - better debugger & development tooling,
  - working on bigger OOP framework code base ( e.x. utils for strings, dates & float numbers, enhance collections, support for parallel programming, etc. )
  - providing a packaging system allowing to publish and share code easily between developers,  
  - considering Bash 3+ support,
  - more ...

---

BeSharp by Maciej Ostrowski (c) 2022
