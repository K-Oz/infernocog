# Inferno OS Scheme Architecture

This document describes the Inferno operating system architecture and its integration with OpenCog through GNU Guix packaging.

## Overview

Inferno is a distributed operating system originally developed at Bell Labs. It provides a concurrent programming environment with unique features:

- **Everything is a File**: All system resources are accessed through a file-based interface
- **9P Protocol**: Network-transparent resource access
- **Limbo Language**: Concurrent programming language with CSP-style channels
- **Dis Virtual Machine**: Portable execution environment
- **Distributed by Design**: Built for network-wide resource sharing

## Core Architecture

### System Structure

```scheme
(define-public inferno-base
  (package
    (name "inferno")
    (version "1.0.0")
    (source (local-file "." "inferno-source" #:recursive? #t))
    (build-system gnu-build-system)
    (synopsis "Inferno distributed operating system")
    (description "Inferno distributed OS with Limbo language and 9P protocol")
    (home-page "https://github.com/K-Oz/infernocog")
    (license (list gpl2+ lgpl2.1+))))
```

### Essential Libraries

#### lib9 - Plan 9 Compatibility Library
```scheme
(native-inputs
 `(("lib9" ,(file-append inferno-base "/lib/lib9.a"))))
```

Core utilities providing Plan 9 API compatibility:
- String manipulation
- Memory management  
- Regular expressions
- Thread primitives

#### libbio - Buffered I/O
```scheme
(native-inputs
 `(("libbio" ,(file-append inferno-base "/lib/libbio.a"))))
```

Efficient buffered I/O operations:
- Stream processing
- Format conversion
- Network I/O abstraction

#### libmath - Mathematical Operations
```scheme
(native-inputs
 `(("libmath" ,(file-append inferno-base "/lib/libmath.a"))))
```

Mathematical library providing:
- Floating-point operations
- Transcendental functions
- Random number generation

### Build System Integration

#### mk - Inferno Make Tool
The `mk` tool provides dependency-driven builds:

```bash
# Build essential libraries
mk lib9/install
mk libbio/install  
mk libmath/install
mk utils/iyacc/install
```

#### iyacc - Parser Generator
Generates parsers for Limbo and other languages:

```bash
iyacc grammar.y  # Generates parser from grammar
```

## Integration Points

### With OpenCog

1. **AtomSpace as File System**
   - OpenCog atoms exposed as Inferno files
   - Query operations through file reads/writes
   - Knowledge base mounted as 9P file system

2. **CogServer as Inferno Service**
   - CogServer runs as Inferno service
   - Network access via 9P protocol
   - Service discovery through Inferno registry

3. **Distributed Reasoning**
   - OpenCog reasoning distributed across Inferno nodes
   - Process migration for load balancing
   - Fault tolerance through process restart

### File System Integration

```scheme
(define opencog-filesystem
  '((atomspace
     (atoms/
      (concept/ ...)
      (predicate/ ...)
      (link/ ...))
     (queries/
      (pattern-matcher)
      (backward-chainer)
      (forward-chainer)))
    (cogserver
     (sessions/
      (session-1/)
      (session-2/))
     (modules/
      (python-bridge)
      (scheme-bridge)))))
```

### Process Architecture

#### Service Processes
- **cogserverd**: Main OpenCog server daemon
- **atomspaced**: AtomSpace persistence service  
- **reasonerd**: Distributed reasoning coordinator
- **bioagid**: Bioinformatics AGI service

#### Client Processes
- **cogshell**: Interactive OpenCog shell
- **atomquery**: AtomSpace query tool
- **reasonctl**: Reasoning control interface

## Configuration Scheme

### System Configuration
```scheme
(inferno-config
  (services
    (opencog
      (atomspace-size "1GB")
      (reasoning-threads 4)
      (network-port 17001)))
  (filesystems
    (atomspace "/n/atoms")
    (knowledge "/n/kb")
    (models "/n/models")))
```

### Security Model
- OpenCog services run in sandboxed namespaces
- AtomSpace access controlled by Inferno authentication
- Network services protected by 9P authentication
- Knowledge bases encrypted at rest

## Development Environment

### Manifest Configuration
```scheme
(packages->manifest
 (list inferno-base
       cogutil
       atomspace
       cogserver
       attention
       opencog-core
       agi-bio
       ;; Development tools
       gcc
       cmake
       make
       pkg-config))
```

### Build Dependencies
```scheme
(native-inputs
 `(("inferno-libs" ,(list (file-append inferno-base "/lib/lib9.a")
                         (file-append inferno-base "/lib/libbio.a")
                         (file-append inferno-base "/lib/libmath.a")))
   ("inferno-headers" ,(file-append inferno-base "/include"))
   ("mk-tool" ,(file-append inferno-base "/bin/mk"))
   ("iyacc-tool" ,(file-append inferno-base "/bin/iyacc"))))
```

## Performance Characteristics

### Memory Management
- Shared memory spaces across distributed nodes
- Copy-on-write for efficient atom replication
- Garbage collection coordinated across cluster

### Network Efficiency  
- 9P protocol minimizes network overhead
- Caching of frequently accessed atoms
- Lazy evaluation of distributed queries

### Scalability
- Horizontal scaling through Inferno node addition
- Automatic load balancing of reasoning tasks
- Fault tolerance through process migration

## Advantages of Integration

1. **Unified Resource Model**: Everything accessible as files
2. **Network Transparency**: Local and remote resources identical
3. **Concurrent Programming**: CSP model perfect for AGI
4. **Distributed by Design**: Natural scaling across machines
5. **Security**: Built-in authentication and encryption
6. **Portability**: Runs on any supported architecture

This architecture creates a powerful platform for distributed artificial general intelligence systems, combining Inferno's distributed computing capabilities with OpenCog's cognitive reasoning power.