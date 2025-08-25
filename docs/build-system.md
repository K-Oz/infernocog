# InfernoCog Build System and Development Workflow

## Overview

The InfernoCog build system extends Inferno's mk with cognitive-aware capabilities, providing intelligent dependency analysis, attention-driven build prioritization, and distributed cognitive compilation across network nodes.

## Traditional Inferno Build System

### Core Build Components

1. **mk**: Dependency-driven build tool
2. **mkconfig**: Platform configuration
3. **mkfiles**: Shared build rules
4. **Compiler Toolchain**: Platform-specific compilers

### Standard Build Workflow

```bash
# 1. Set up build environment
export ROOT=/usr/inferno
export SYSHOST=Linux
export OBJTYPE=386

# 2. Build essential libraries
mk lib9/install
mk libbio/install  
mk libmath/install

# 3. Build applications
mk all

# 4. Install
mk install
```

### Mkfile Structure

```makefile
# Platform configuration
<../mkconfig

# Application details
TARG=myapp
OFILES=main.$O utils.$O

# Standard rules
<../mkone

# Custom rules
special.$O: special.c special.h
    $CC $CFLAGS -DSPECIAL special.c
```

## InfernoCog Cognitive Build System

### Enhanced Build Features

1. **Intelligent Dependencies**: AI-driven dependency analysis
2. **Attention Prioritization**: Build important components first
3. **Distributed Compilation**: Leverage cognitive compute clusters
4. **Learning Integration**: Optimize builds from historical patterns
5. **Cognitive Testing**: Integrated AGI-aware testing

### Cognitive Build Environment

```bash
# Set up cognitive build environment
export COGNITIVE_MODE=enabled
export ATOMSPACE_PATH=/n/atomspace/build
export ATTENTION_CONFIG=attention.cfg
export COGNITIVE_NODES=`{cat cognitive-cluster.cfg}

# Enable distributed cognitive builds
export DISTRIBUTED_BUILD=true
export BUILD_LEARNING=enabled
```

### Cognitive Mkfile Extensions

```makefile
# Cognitive build configuration
<../mkconfig
<../cogconfig

TARG=cognitive-app
OFILES=main.$O reasoning.$O atomspace.$O attention.$O

# Cognitive flags
COGFLAGS=-DAGI_ENABLED -DOPENICOG_INTEGRATION
CFLAGS=$CFLAGS $COGFLAGS

# Attention-based priorities
core.$O:A=0.9: core.c
    $CC $CFLAGS -priority high core.c

# Cognitive dependencies
reasoning.$O: reasoning.c atomspace.h cognitive.h
    cog-analyze-deps reasoning.c
    $CC $CFLAGS reasoning.c

# Distributed compilation
heavy-compute.$O: heavy-compute.c
    mk-distribute $COGNITIVE_NODES $CC heavy-compute.c

# Cognitive testing
test:V: $TARG
    cogtest -reasoning $TARG
    cogtest -attention $TARG
    cogtest -learning $TARG

<../mkone
```

## Intelligent Dependency Analysis

### Traditional Dependencies

Traditional mk tracks file modification times:

```makefile
prog: main.$O lib.$O
    $LD -o prog main.$O lib.$O

main.$O: main.c main.h lib.h
    $CC main.c
```

### Cognitive Dependencies

InfernoCog adds semantic and cognitive dependencies:

```makefile
# Semantic dependency analysis
main.$O: main.c
    semantic-analyze main.c > main.deps
    $CC main.c

# Include semantic dependencies
<main.deps

# Cognitive data dependencies
reasoning.$O: reasoning.c $(ATOMSPACE_PATH)/schemas/*.scm
    cognitive-deps reasoning.c
    $CC reasoning.c

# Learning-based dependencies
adaptive.$O: adaptive.c
    learning-deps adaptive.c $(BUILD_HISTORY)
    $CC adaptive.c
```

### Dependency Learning

The system learns dependency patterns over time:

```bash
# Enable dependency learning
mk -learn-deps all

# Analyze learned patterns
mk-analyze-deps build-history.log

# Apply learned optimizations
mk -apply-learned all
```

## Attention-Driven Build Prioritization

### Attention Configuration

Define build priorities based on attention values:

```bash
# attention.cfg
core.c:0.9          # Critical system components
main.c:0.8          # Main application logic
utils.c:0.6         # Utility functions  
tests.c:0.3         # Test code
docs.c:0.1          # Documentation
```

### Attention-Aware Builds

```makefile
# Read attention configuration
<$ATTENTION_CONFIG

# Attention-prioritized rules
%.O: %.c
    attention-priority $stem.c
    $CC $CFLAGS $stem.c

# Dynamic attention adjustment
adaptive-build:V:
    attention-analyze recent-changes.log
    mk-cognitive -dynamic-attention all
```

### Build Queue Management

High-attention components are built first:

```bash
# Start attention-aware build
mk-cognitive -attention-queue all

# Monitor build priorities  
watch mk-attention-status

# Adjust priorities dynamically
echo "main.c:0.95" >> attention.cfg
mk-attention-update
```

## Distributed Cognitive Builds

### Cognitive Build Cluster

Set up a distributed cognitive build environment:

```bash
# cognitive-cluster.cfg
node1:tcp!node1!17003:compiler,linker
node2:tcp!node2!17003:compiler,heavy-compute
node3:tcp!node3!17003:compiler,tests
node4:tcp!node4!17003:analysis,optimization
```

### Distributed Compilation

```makefile
# Distributed build configuration
COGNITIVE_NODES=`{cat cognitive-cluster.cfg}
DIST_THRESHOLD=1000   # Distribute files > 1000 lines

# Automatic distribution  
%.$O: %.c
    if(test `{wc -l $stem.c | awk '{print $1}'} -gt $DIST_THRESHOLD) {
        mk-distribute $COGNITIVE_NODES $CC $stem.c
    } else {
        $CC $stem.c
    }

# Force distributed compilation
heavy-module.$O: heavy-module.c
    mk-distribute $COGNITIVE_NODES $CC heavy-module.c

# Distributed linking
$TARG: $OFILES
    mk-distribute-link $COGNITIVE_NODES $LD -o $TARG $OFILES
```

### Load Balancing

Intelligent distribution based on node capabilities:

```bash
# Monitor node loads
mk-node-status $COGNITIVE_NODES

# Balance workload
mk-balance-load all

# Adaptive distribution
mk-adaptive-distribute all
```

## Build Learning and Optimization

### Historical Build Analysis

Learn from previous builds to optimize future ones:

```makefile
# Enable build learning
BUILD_LEARNING=true

# Track build metrics
all:V:
    build-metrics-start
    mk traditional-build
    build-metrics-end
    build-learn update-models
```

### Predictive Builds

Predict what needs rebuilding before changes are made:

```bash
# Predict rebuild requirements
mk-predict changes.diff

# Preemptive builds
mk-preemptive predicted-changes.list

# Smart incremental builds
mk-smart-incremental
```

### Build Optimization

Automatic optimization based on learned patterns:

```makefile
# Optimization learning
optimize-build:V:
    build-optimizer -analyze build-history.log
    build-optimizer -generate optimized-rules.mk
    
# Apply optimizations
<optimized-rules.mk

# Continuous optimization
continuous-optimize:V:
    while(true) {
        mk-build-and-learn all
        sleep 3600  # Re-optimize hourly
    }
```

## Cognitive Testing Integration

### Traditional Testing

```makefile
test:V: $TARG
    ./$TARG < test-input.txt > test-output.txt
    diff test-output.txt expected-output.txt
```

### Cognitive Testing

```makefile
# Cognitive test suite
cogtest:V: $TARG
    cogtest-reasoning $TARG
    cogtest-learning $TARG  
    cogtest-attention $TARG
    cogtest-atomspace $TARG

# Reasoning validation
test-reasoning:V: $TARG
    echo "(ConceptNode cat)" | $TARG -reasoning
    cogvalidate reasoning-output.scm

# Learning verification
test-learning:V: $TARG
    $TARG -learn training-data.txt
    cogvalidate learned-knowledge.atoms

# Attention dynamics testing
test-attention:V: $TARG
    $TARG -attention-trace attention-test.script
    cogvalidate attention-dynamics.log
```

### Automated Cognitive Testing

```makefile
# Continuous cognitive testing
continuous-test:V:
    while(true) {
        mk cogtest
        cogtest-report > test-results.json
        if(cogtest-failures test-results.json) {
            alert-developers
        }
        sleep 1800  # Test every 30 minutes
    }
```

## Development Workflow

### Cognitive Application Development

1. **Environment Setup**:
   ```bash
   # Set up cognitive development environment
   mkdir myproject && cd myproject
   cp $INFERNO_ROOT/templates/cognitive-mkfile mkfile
   cp $INFERNO_ROOT/templates/attention.cfg .
   ```

2. **Project Structure**:
   ```
   myproject/
   ├── mkfile              # Build configuration
   ├── attention.cfg       # Attention priorities
   ├── cognitive.cfg       # Cognitive settings
   ├── src/               # Source code
   ├── schemas/           # Cognitive schemas
   ├── tests/             # Test suite
   └── docs/              # Documentation
   ```

3. **Development Cycle**:
   ```bash
   # Code and test iteratively
   edit src/main.c
   mk cogtest              # Cognitive testing
   mk install              # Install if tests pass
   ```

4. **Cognitive Debugging**:
   ```bash
   # Debug cognitive functionality
   cogdb myapp
   
   # Attention debugging
   mk-attention-trace myapp
   
   # AtomSpace inspection
   atominspect /n/atomspace/myapp
   ```

## Integration Examples

### Simple Cognitive Application

```makefile
# mkfile for simple cognitive app
<../mkconfig
<../cogconfig

TARG=simple-cog
OFILES=main.$O cognitive.$O

COGFLAGS=-DAGI_ENABLED
CFLAGS=$CFLAGS $COGFLAGS

<../mkone

# Cognitive dependencies
cognitive.$O: cognitive.c $(ATOMSPACE_PATH)/core.scm
    $CC $CFLAGS cognitive.c

# Cognitive testing
test:V: $TARG
    cogtest-basic $TARG
```

### Complex Distributed Application

```makefile
# mkfile for distributed cognitive system
<../mkconfig
<../cogconfig

TARG=distributed-cog
DIRS=reasoning learning attention interface

# Distributed build
all:V:
    for(i in $DIRS) {
        cd $i && mk-cognitive all &
    }
    wait
    mk assemble

# Assemble distributed components
assemble:V:
    cognitive-assembler -config distributed.cfg
    
# Distributed testing
test:V: all
    mk-distributed-test cognitive-cluster.cfg

# Deployment
deploy:V: all test
    mk-cognitive-deploy production-cluster.cfg
```

## Performance Monitoring

### Build Performance Metrics

```bash
# Monitor build performance
mk-metrics-start
mk all
mk-metrics-end

# Analyze performance
mk-analyze-performance build-metrics.json

# Optimize based on metrics
mk-optimize-from-metrics
```

### Cognitive Build Analytics

```bash
# Cognitive build analysis
cognitive-build-analyzer build-history.log

# Attention effectiveness analysis
attention-analyzer attention-log.txt

# Learning progress tracking
learning-tracker learning-progress.json
```

## Best Practices

### Cognitive Build Guidelines

1. **Attention Configuration**: Regularly update attention priorities
2. **Distributed Builds**: Use for compute-intensive components
3. **Learning Integration**: Enable build learning for large projects
4. **Testing**: Always include cognitive testing
5. **Monitoring**: Track cognitive build metrics

### Performance Optimization

1. **Parallel Builds**: Use `NPROC` for CPU cores
2. **Distributed Computing**: Leverage cognitive clusters
3. **Caching**: Enable build result caching
4. **Incremental Builds**: Minimize unnecessary rebuilds
5. **Attention-based Prioritization**: Focus on important components

### Debugging Tips

1. **Verbose Mode**: Use `mk -v` for detailed output
2. **Cognitive Tracing**: Enable cognitive decision tracing
3. **Dependency Analysis**: Visualize dependency graphs
4. **Performance Profiling**: Profile build performance
5. **Error Recovery**: Use robust error handling

## See Also

- [mk](mk.md) - Core build tool documentation
- [lib9](lib9.md) - Core library with cognitive extensions
- [agi-integration](agi-integration.md) - Overall AGI integration guide
- [Inferno Build](../doc/install.pdf) - Traditional build documentation
- [OpenCog Build](https://wiki.opencog.org/w/Building_OpenCog) - OpenCog build patterns