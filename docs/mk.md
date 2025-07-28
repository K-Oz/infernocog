# mk: Dependency-Driven Build Tool

## Overview

mk is Inferno's dependency-driven build tool, inspired by Plan 9's mk. It provides a powerful, flexible build system that supports parallel execution, pattern rules, and network-transparent builds. Unlike traditional make, mk uses a cleaner syntax and integrates seamlessly with Inferno's distributed computing environment.

## Inferno Base System

### Design Philosophy

mk embodies Plan 9's build system principles:
- **Simple Syntax**: Clean, readable build specifications
- **Pattern Rules**: Powerful meta-rules for implicit dependencies
- **Parallel Execution**: Automatic parallel build optimization
- **Network Transparency**: Distributed builds across Inferno network
- **Incremental Updates**: Efficient rebuilds of only changed components

### Core Concepts

#### Mkfile Structure
A mkfile contains assignments and rules:

```makefile
# Variable assignments
CC=8c
LD=8l
O=8

# Simple rule
prog: main.$O sub.$O
    $LD -o prog main.$O sub.$O

# Pattern rule (meta-rule)
%.$O: %.c
    $CC $stem.c
```

#### Rule Components
- **Target**: File to be built
- **Prerequisites**: Dependencies that trigger rebuilds
- **Recipe**: Shell commands to build the target
- **Attributes**: Special behavior modifiers

#### Variables and Substitution
```makefile
OFILES=main.$O sub.$O util.$O

# String substitution
CFILES=${OFILES:%.$O=%.c}

# Command substitution
FILES=`{ls *.c}
```

### Advanced Features

#### Meta-Rules (Pattern Rules)
Meta-rules define templates for building files:

```makefile
# Basic pattern rule
%.dis: %.b
    limbo -o $target $prereq

# Complex pattern with multiple files
%: %.c lib%.c
    $CC -o $target $prereq

# Regular expression meta-rule
([^/]*)/(.*)\.dis:R: \1/\2.b
    cd $stem1; limbo -o $stem2.dis $stem2.b
```

#### Attributes
Rules can have attributes that modify behavior:

- `V` - Virtual target (not a file)
- `Q` - Quiet execution (don't print recipe)
- `D` - Delete target on failure
- `E` - Continue on error
- `N` - Update timestamp without executing
- `P` - Use custom program for date comparison

```makefile
all:V: prog tests
    echo "Build complete"

clean:QV:
    rm -f *.$O prog
```

#### Parallel Execution
mk automatically detects independent targets and builds them in parallel:

```bash
export NPROC=4  # Use 4 parallel processes
mk all
```

### Environment Integration

#### Built-in Variables
mk provides several built-in variables:

- `$target` - Current target being built
- `$prereq` - All prerequisites
- `$newprereq` - Prerequisites newer than target
- `$stem` - Matched portion in meta-rules
- `$alltarget` - All targets in multi-target rule
- `$nproc` - Process slot number (0 to NPROC-1)

#### Environment Variables
Important environment variables:

- `NPROC` - Number of parallel processes
- `SHELL` - Shell program for recipe execution
- `OBJTYPE` - Target architecture
- `SYSTARG` - Target system

### Common Patterns

#### Library Building
```makefile
LIB=libmylib.a
OFILES=mod1.$O mod2.$O mod3.$O

$LIB: $OFILES
    ar rvc $LIB $OFILES

%.$O: %.c
    $CC $CFLAGS $stem.c
```

#### Installation Rules
```makefile
TARG=myprog
BIN=/$OBJTYPE/bin

install:V: $BIN/$TARG

$BIN/$TARG: $TARG
    cp $prereq $target
```

#### Recursive Builds
```makefile
DIRS=lib cmd appl

all:V:
    for(i in $DIRS) @{cd $i && mk $target}

nuke:V:
    for(i in $DIRS) @{cd $i && mk $target}
    rm -f *.[$OS] [$OS].out
```

## InfernoCog AGI Implementation

### Cognitive Build Enhancement

InfernoCog extends mk with AGI-aware build capabilities:

#### Intelligent Dependency Analysis
```makefile
# AGI-enhanced dependency detection
COGFLAGS=-DAGI_ENABLED -DCOGNITIVE_BUILD

# Automatic cognitive dependency detection
%.dis: %.b
    limbo $COGFLAGS -cognitive-deps $stem.b
    mv $stem.dis.deps .deps/$stem.deps

# Include cognitive dependencies
<include .deps/*.deps
```

#### Attention-Driven Build Prioritization
```makefile
# Attention-based build ordering
ATTENTION_CONFIG=attention.cfg

all:V:
    mk-cognitive -attention $ATTENTION_CONFIG $target

# High-attention targets built first
core.dis:A=0.9: core.b
    limbo -priority high $prereq

# Low-attention targets deferred
test.dis:A=0.1: test.b
    limbo -priority low $prereq
```

#### Cognitive Test Integration
```makefile
# AGI-enhanced testing
COGTEST=cogtest

test:V: $TARG
    $COGTEST -reasoning $TARG
    $COGTEST -learning $TARG
    $COGTEST -attention $TARG

# Pattern-based cognitive testing
%.test:V: %.dis
    $COGTEST -pattern $stem.dis
```

### Distributed Cognitive Builds

#### Multi-Node Build Distribution
```makefile
# Distributed build configuration
COGNODES=`{cat cognodes.txt}
DISTFLAGS=-distributed -nodes $COGNODES

# Distributed compilation
%.$O: %.c
    mk-distribute $DISTFLAGS $CC $stem.c

# Cognitive workload balancing
heavy-compute.dis: heavy-compute.b
    mk-cognitive-balance limbo $prereq
```

#### AtomSpace-Aware Builds
```makefile
# AtomSpace integration during build
ATOMSPACE_PATH=/n/atomspace

# Generate cognitive schemas during build
%.scm: %.b
    limbo-cognitive -atomspace $ATOMSPACE_PATH -extract-schemas $stem.b

# Update AtomSpace with build artifacts
install-cognitive:V: $TARG
    coginstall -atomspace $ATOMSPACE_PATH $TARG
```

### Build Intelligence Features

#### Learning from Build Patterns
```makefile
# Machine learning for build optimization
BUILDML=build-ml

all:V:
    $BUILDML -learn-start
    mk traditional-build
    $BUILDML -learn-end -optimize future-builds
```

#### Predictive Rebuilds
```makefile
# Predictive dependency analysis
PREDICT=predict-deps

%.predict: %.c
    $PREDICT -analyze $stem.c
    @{if(test -f $stem.predict) echo $stem.c may need rebuilding}
```

#### Cognitive Error Recovery
```makefile
# Intelligent error handling
ERRORAI=error-ai

%.$O: %.c
    @{
        $CC $stem.c || {
            $ERRORAI -diagnose $stem.c
            $ERRORAI -suggest-fix $stem.c
            exit 1
        }
    }
```

### Integration with OpenCog

#### Scheme Code Generation
```makefile
# Generate Scheme code for OpenCog integration
%.scm: %.limbo-schema
    schema2scm -input $prereq -output $target

# AtomSpace population during build
populate-atomspace:V: schemas
    for(i in *.scm) opencog-load $i
```

#### Cognitive Build Metrics
```makefile
# Collect cognitive build statistics
COGMETRICS=cog-metrics

all:V:
    $COGMETRICS -start
    mk build-all
    $COGMETRICS -end -report build-intelligence.json
```

## Examples

### Basic Inferno Application

```makefile
# Simple Inferno application mkfile
<../mkconfig

TARG=myapp
OFILES=main.$O util.$O parser.$O

<../mkone

# Pattern rule for C compilation
%.$O: %.c
    $CC $CFLAGS $stem.c

# Generate parser from yacc grammar
parser.c: parser.y
    $YACC -d parser.y
    mv y.tab.c parser.c
    mv y.tab.h parser.h

# Installation
install:V: $BIN/$TARG

$BIN/$TARG: $TARG
    cp $prereq $target

# Cleanup
nuke:V:
    rm -f *.$O $TARG y.tab.* parser.[ch]
```

### Complex Multi-Module Build

```makefile
# Multi-module Inferno project
<../mkconfig

DIRS=lib cmd appl doc

# Recursive build across modules
all:V:
    for(i in $DIRS) @{
        echo Building $i...
        cd $i && mk $target
    }

install:V:
    for(i in $DIRS) @{
        cd $i && mk $target
    }

# Parallel cleanup
nuke:V:
    for(i in $DIRS) @{
        cd $i && mk $target &
    }
    wait

# Documentation generation
docs:V: doc
    cd doc && mk all
    mk man-install

man-install:V:
    cp doc/*.man $MANPATH/
```

### InfernoCog Cognitive Application

```makefile
# InfernoCog cognitive application mkfile
<../mkconfig

TARG=cogapp
OFILES=main.$O reasoning.$O atomspace.$O attention.$O
COGLIBS=libcognitive.a libatomspace.a

# Cognitive compilation flags
COGFLAGS=-DAGI_ENABLED -DOPENICOG_INTEGRATION
CFLAGS=$CFLAGS $COGFLAGS

<../mkone

# Cognitive-enhanced compilation
%.$O: %.c
    $CC $CFLAGS -cognitive-analysis $stem.c

# AtomSpace schema generation
schemas.scm: $OFILES
    extract-schemas $prereq > $target

# Cognitive testing
test:V: $TARG schemas.scm
    cogtest -atomspace schemas.scm $TARG
    cogtest -reasoning $TARG
    cogtest -attention-dynamics $TARG

# Intelligent installation with AtomSpace update
install-cognitive:V: $BIN/$TARG schemas.scm
    cp $TARG $BIN/
    coginstall -schemas schemas.scm -target $TARG

# Cognitive profiling build
profile:V: $TARG
    cogprof -build $TARG
    cogprof -analyze > cognitive-profile.txt

# Distributed build across cognitive nodes
distributed:V:
    mk-cognitive-distribute -nodes cognitive-cluster.cfg all
```

### AtomSpace-Integrated Build

```makefile
# Build system integrated with AtomSpace
ATOMSPACE=/n/atomspace/build
COGSCHEMAS=$ATOMSPACE/schemas

# Cognitive dependency tracking
%.cognitive-deps: %.c
    cognitive-analyze -deps $stem.c > $target

# Include cognitive dependencies
DEPFILES=`{ls *.cognitive-deps}
<$DEPFILES

# Build with AtomSpace integration
%.$O: %.c
    $CC -atomspace-connect $ATOMSPACE $stem.c

# Update AtomSpace with build knowledge
build-knowledge:V: $TARG
    build-analyzer -extract-knowledge $TARG | \
    atomspace-import -space $ATOMSPACE

# Cognitive build optimization
optimize-build:V:
    cognitive-optimizer -analyze build-history.log
    cognitive-optimizer -generate optimized.mk
```

## Performance and Optimization

### Build Performance Tips

1. **Parallel Builds**: Set `NPROC` to CPU count
2. **Pattern Rules**: Use specific patterns to avoid excessive matching
3. **Incremental Builds**: Minimize unnecessary rebuilds with proper dependencies
4. **Network Builds**: Use local caching for remote dependencies

### Cognitive Build Optimization

1. **Attention Management**: Prioritize high-importance components
2. **Learning Integration**: Use build history for optimization
3. **Distributed Processing**: Leverage cognitive compute nodes
4. **AtomSpace Efficiency**: Batch AtomSpace operations

### Debugging

```bash
# Enable mk debugging
mk -d eg all          # Show execution and graph building
mk -e all             # Explain why targets are built
mk -n all             # Show commands without executing

# Cognitive build debugging
mk -cognitive-debug all    # Show cognitive decision making
mk -attention-trace all    # Trace attention-based prioritization
```

## Command Line Options

### Standard Options
- `-a` - Assume all targets out of date
- `-e` - Explain why each target is made
- `-f file` - Use alternate mkfile
- `-i` - Force missing intermediate targets
- `-k` - Keep going on errors
- `-n` - Print commands without executing
- `-s` - Sequential execution
- `-t` - Touch files instead of executing

### InfernoCog Extensions
- `-cognitive` - Enable cognitive build features
- `-attention file` - Use attention configuration
- `-distributed` - Enable distributed cognitive builds
- `-atomspace path` - Connect to AtomSpace
- `-learn` - Enable build pattern learning

## See Also

- [lib9](lib9.md) - Core library integration
- [iyacc](iyacc.md) - Parser generator integration
- [mk Manual](../man/1/mk) - Complete mk command reference
- [Plan 9 mk](../doc/mk.pdf) - Original mk design document
- [OpenCog Build](https://wiki.opencog.org/w/Building_OpenCog) - Cognitive build patterns