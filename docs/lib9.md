# lib9: Plan 9 Compatibility Library

## Overview

lib9 is the fundamental compatibility library that provides Plan 9 system call interfaces and core utilities for Inferno applications running on various host operating systems. It serves as the foundation layer enabling Inferno's distributed computing paradigm across heterogeneous platforms.

## Inferno Base System

### Design Philosophy

lib9 embodies Plan 9's core design principles:
- **Everything is a file**: Uniform interface for system resources
- **Unicode throughout**: Native UTF-8 and Rune support
- **Network transparency**: Seamless distributed operation
- **Clean interfaces**: Minimal, orthogonal system calls

### Core Components

#### String and Text Processing
- **UTF-8/Rune Operations**: Complete Unicode support with functions like `utflen()`, `utfrune()`, `runestrchr()`
- **Format Printing**: Extensible printf family (`print()`, `fprint()`, `snprint()`, `vsnprint()`)
- **String Utilities**: Plan 9 style string functions (`tokenize()`, `getfields()`, `strecpy()`)

#### File and Directory Operations
- **9P Protocol Support**: Conversion functions (`convS2M()`, `convM2S()`, `convD2M()`, `convM2D()`)
- **Directory Handling**: Plan 9 directory structure support (`dirstat()`, `dirwstat()`, `nulldir()`)
- **File Creation**: Network-transparent file operations (`create()`)

#### Memory Management
- **Allocation**: Plan 9 style memory allocation
- **Error Handling**: Structured error reporting (`errstr()`, `rerrstr()`, `sysfatal()`)
- **Process Control**: Basic process management primitives

#### Synchronization
- **Locks**: Cross-platform locking primitives (`lock()`, `unlock()`)
- **Threading**: Support for concurrent operations

### Platform Portability

lib9 provides platform-specific implementations for:
- **Linux**: Full POSIX compatibility layer
- **Windows (Nt)**: Win32 API bridge
- **macOS**: Darwin-specific optimizations  
- **FreeBSD/OpenBSD/NetBSD**: BSD variants support
- **Solaris**: SPARC and x86 implementations
- **AIX**: PowerPC support

Each platform maintains the same API while adapting to underlying system differences.

### API Reference

#### Core Functions

```c
// String operations
int     utflen(char *s);
char*   utfrune(char *s, Rune c);
int     runestrlen(Rune *r);
char*   runestrchr(Rune *r, Rune c);

// Formatted output
int     print(char *fmt, ...);
int     fprint(int fd, char *fmt, ...);
int     snprint(char *buf, int len, char *fmt, ...);

// File operations  
int     create(char *file, int omode, ulong perm);
Dir*    dirstat(char *file);
int     dirwstat(char *file, Dir *d);

// Error handling
void    errstr(char *buf, int n);
void    rerrstr(char *buf, int n);
void    sysfatal(char *fmt, ...);

// Memory
void*   malloc(ulong n);
void*   realloc(void *p, ulong n);
void    free(void *p);
```

## InfernoCog AGI Implementation

### Cognitive Enhancements

InfernoCog extends lib9 with AGI-aware capabilities that enable seamless integration with OpenCog's cognitive architecture:

#### AtomSpace Integration
- **Atom Serialization**: Custom format functions for OpenCog atoms
- **Hypergraph I/O**: Efficient reading/writing of cognitive structures
- **Type System Bridge**: Mapping between Plan 9 types and OpenCog atom types

```c
// AGI-specific extensions (InfernoCog)
int     atomprint(int fd, Atom *atom);
Atom*   parseatomstr(char *str);
int     hypergraphwrite(int fd, AtomSpace *as);
AtomSpace* hypergraphread(int fd);
```

#### Distributed Reasoning Support
- **Node Discovery**: Automatic detection of cognitive processing nodes
- **Load Balancing**: Distribute reasoning workload across Inferno network
- **Fault Tolerance**: Graceful handling of node failures during cognitive processing

```c
// Distributed AGI functions
int     cognode_discover(char *netaddr, CogNode *nodes, int maxnodes);
int     reason_distribute(ReasonRequest *req, CogNode *nodes, int nnodes);
void    cogfault_handler(void (*handler)(CogNode *failed));
```

#### Memory-Mapped AtomSpace
- **Shared Cognitive State**: Memory-mapped access to distributed AtomSpace
- **Concurrent Access**: Multiple Inferno processes sharing cognitive data
- **Persistence**: Automatic AtomSpace persistence across system restarts

```c
// Memory-mapped cognitive data
AtomSpace* atomspace_map(char *path, int flags);
int     atomspace_sync(AtomSpace *as);
void    atomspace_unmap(AtomSpace *as);
```

### Cognitive Format Extensions

InfernoCog adds new format specifiers to the printf family for cognitive data:

- `%A` - Print Atom with type and truth value
- `%H` - Print hypergraph structure
- `%T` - Print TruthValue with confidence intervals
- `%C` - Print cognitive statistics

```c
// Example usage
Atom *concept = conceptnode_new("cat");
print("Learned concept: %A\n", concept);
print("Truth value: %T\n", atom_get_tv(concept));
```

### File System Cognitive Interface

InfernoCog exposes OpenCog services through Inferno's file system interface:

#### /n/atomspace/ Namespace
- `/n/atomspace/concepts/` - Concept nodes as files
- `/n/atomspace/predicates/` - Predicate relationships  
- `/n/atomspace/query` - Query interface for pattern matching
- `/n/atomspace/stats` - Cognitive processing statistics

#### /n/reasoning/ Namespace
- `/n/reasoning/forward` - Forward chaining inference
- `/n/reasoning/backward` - Backward chaining queries
- `/n/reasoning/pattern` - Pattern mining operations
- `/n/reasoning/attention` - Attention allocation control

### Build Integration

lib9 AGI extensions integrate with the mk build system:

```makefile
# InfernoCog-specific targets
COGFLAGS=-DAGI_ENABLED -DATOMSPACE_MMAP
lib9.a: lib9-base.a lib9-agi.a
    ar rvc lib9.a lib9-base/*.o lib9-agi/*.o

lib9-agi.a: atomspace.$O hypergraph.$O cognitive.$O
    ar rvc lib9-agi.a atomspace.$O hypergraph.$O cognitive.$O
```

### Performance Optimizations

InfernoCog lib9 includes cognitive-aware optimizations:

1. **AtomSpace Indexing**: Hash-based atom lookup for O(1) access
2. **Lazy Evaluation**: Deferred computation of cognitive relationships  
3. **Cache Coherency**: Distributed cache invalidation for shared cognitive state
4. **Parallel Processing**: Multi-threaded cognitive operations

### Configuration

AGI features are controlled via environment variables:

```bash
# Enable AtomSpace memory mapping
export ATOMSPACE_MMAP=1

# Set distributed reasoning timeout  
export REASON_TIMEOUT=30

# Configure cognitive cache size
export COGCACHE_SIZE=64M

# Enable cognitive debugging
export COGDEBUG=1
```

## Examples

### Basic Inferno Usage

```c
#include "lib9.h"

void
main(void)
{
    char buf[256];
    int fd;
    
    // Create a file using Plan 9 semantics
    fd = create("/tmp/test", OWRITE, 0644);
    if(fd < 0) {
        errstr(buf, sizeof buf);
        sysfatal("create failed: %s", buf);
    }
    
    // Use Plan 9 formatted output
    fprint(fd, "Hello from Inferno\n");
    close(fd);
}
```

### InfernoCog AGI Usage

```c
#include "lib9.h"
#include "cognitive.h"

void
agi_example(void)
{
    AtomSpace *as;
    Atom *cat, *animal, *isa;
    
    // Map shared AtomSpace
    as = atomspace_map("/n/atomspace/shared", OREAD|OWRITE);
    
    // Create cognitive concepts
    cat = conceptnode_new("cat");
    animal = conceptnode_new("animal");
    isa = evaluationlink_new(predicatenode_new("isa"), cat, animal);
    
    // Add to AtomSpace with cognitive formatting
    atomspace_add(as, cat);
    atomspace_add(as, animal);  
    atomspace_add(as, isa);
    
    print("Added relationship: %A\n", isa);
    
    // Sync distributed AtomSpace
    atomspace_sync(as);
    atomspace_unmap(as);
}
```

## See Also

- [libbio](libbio.md) - Buffered I/O operations
- [mk](mk.md) - Build system integration
- [Plan 9 Manual](../man/3/intro) - Original Plan 9 documentation
- [OpenCog AtomSpace](https://wiki.opencog.org/w/AtomSpace) - Cognitive architecture details