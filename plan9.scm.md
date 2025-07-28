# Plan 9 Scheme Architecture

This document describes the Plan 9 operating system architectural principles and their application in the InfernoCog/OpenCog integration.

## Overview

Plan 9 from Bell Labs represents a clean, distributed computing architecture that influenced Inferno OS design. Key principles include:

- **Everything is a File**: All system resources accessed through file operations
- **9P Protocol**: Network file system protocol for distributed resources
- **Namespaces**: Private, composable views of system resources
- **Process Model**: Lightweight processes with message passing
- **UTF-8 Throughout**: Unicode support at the system level

## Core Architectural Principles

### Resource Abstraction

```scheme
(define plan9-resources
  '((files
     (regular-files "/path/to/file")
     (devices "/dev/device")
     (network "/net/tcp")
     (processes "/proc/pid"))
    (namespaces
     (private-view "/private/namespace")
     (shared-view "/shared/namespace")
     (union-view "/union/namespace"))
    (protocols
     (9p "network file system")
     (styx "secure 9p variant"))))
```

### File-Based Interface

All system interaction through file operations:

```scheme
(define file-operations
  '((read "cat /dev/time")           ; Read current time
    (write "echo data > /dev/audio") ; Write to audio device  
    (mount "mount /net/cs /n/cs")    ; Mount network service
    (bind "bind /tmp /n/tmp")        ; Bind directory
    (unmount "unmount /n/service"))) ; Unmount service
```

## OpenCog Integration Architecture

### AtomSpace as Plan 9 File System

```scheme
(define atomspace-filesystem
  '((/n/atomspace
     (atoms/
      (concept/
       (cat #f "ConceptNode")
       (dog #f "ConceptNode")
       (animal #f "ConceptNode"))
      (predicate/
       (isa #f "PredicateNode")
       (likes #f "PredicateNode"))
      (link/
       (inheritance/
        (cat-animal #f "InheritanceLink")
        (dog-animal #f "InheritanceLink"))
       (evaluation/
        (likes-cat #f "EvaluationLink"))))
     (queries/
      (ctl #f "query control")
      (pattern #f "pattern matcher")
      (results/ #f "query results"))
     (stats/
      (atom-count #f "total atoms")
      (memory-usage #f "memory statistics")
      (load-average #f "system load")))))
```

### CogServer as 9P Service

```scheme
(define cogserver-service
  '((announcement
     (name "cogserver")
     (port "17001")
     (protocol "9p")
     (version "2000"))
    (filesystem
     (sessions/
      (new #f "create new session")
      (active/ #f "active sessions"))
     (modules/
      (python #f "Python bridge")
      (scheme #f "Scheme bridge")
      (c++ #f "C++ bridge"))
     (ctl #f "server control"))))
```

### Network Integration

#### Service Discovery
```scheme
(define service-discovery
  '((cs-server "/net/cs")           ; Connection server
    (dns-server "/net/dns")         ; Domain name server  
    (opencog-registry "/net/opencog") ; OpenCog service registry
    (atomspace-services
     (local "tcp!localhost!17001")
     (cluster-1 "tcp!node1!17001")
     (cluster-2 "tcp!node2!17001"))))
```

#### Process Communication
```scheme
(define process-communication
  '((pipes
     (unnamed-pipe "|")
     (named-pipe "/srv/cogpipe"))
    (channels
     (rendezvous "/srv/rendezvous")
     (synchronous "/srv/sync-chan")
     (asynchronous "/srv/async-chan"))
    (shared-memory
     (atomspace "/srv/atoms")
     (knowledge-base "/srv/kb"))))
```

## Namespace Management

### Private Namespaces
Each OpenCog process gets its own namespace:

```scheme
(define private-namespace
  '((atomspace
     (personal "/n/personal-atoms")
     (working "/n/working-set")
     (cache "/n/atom-cache"))
    (services
     (local-cogserver "/n/cogserver")
     (reasoning "/n/reasoner")
     (learning "/n/learner"))
    (data
     (models "/n/models")
     (training "/n/training-data")
     (results "/n/results"))))
```

### Shared Resources
System-wide OpenCog resources:

```scheme
(define shared-resources
  '((global-atomspace "/srv/global-atoms")
    (knowledge-bases "/srv/knowledge")
    (reasoning-engines "/srv/reasoners")
    (learning-modules "/srv/learners")
    (bio-data "/srv/bio-knowledge")))
```

### Union Namespaces
Composite views combining multiple sources:

```scheme
(define union-namespace
  '((combined-atomspace
     (layers
      (personal "/n/personal-atoms")
      (shared "/srv/global-atoms")
      (cached "/n/atom-cache"))
     (priority "personal > cached > shared"))
    (unified-knowledge
     (layers  
      (local-kb "/n/local-knowledge")
      (bio-kb "/srv/bio-knowledge")
      (global-kb "/srv/global-knowledge"))
     (priority "local > bio > global"))))
```

## Process Architecture

### Lightweight Processes
Plan 9-style processes for OpenCog components:

```scheme
(define opencog-processes
  '((reasoning-process
     (type "lightweight")
     (communication "channels")
     (shared-state "atomspace")
     (isolation "namespace"))
    (learning-process
     (type "lightweight")  
     (communication "files")
     (shared-state "models")
     (isolation "namespace"))
    (bio-analysis-process
     (type "lightweight")
     (communication "9p")
     (shared-state "bio-data")
     (isolation "container"))))
```

### Message Passing
CSP-style communication between processes:

```scheme
(define message-patterns
  '((request-response
     (client-sends "/srv/request-chan")
     (server-responds "/srv/response-chan"))
    (publish-subscribe
     (publisher-sends "/srv/pub-chan")
     (subscribers-receive "/srv/sub-chan"))
    (pipeline
     (stage-1-output "/srv/pipe-1")
     (stage-2-input "/srv/pipe-1")
     (stage-2-output "/srv/pipe-2"))))
```

## Security Model

### Authentication
```scheme
(define authentication
  '((user-auth
     (method "challenge-response")
     (credentials "/adm/users")
     (tickets "/srv/tickets"))
    (service-auth
     (method "capability-based")
     (capabilities "/adm/caps")
     (delegation "/srv/delegation"))))
```

### Authorization
```scheme
(define authorization
  '((file-permissions
     (read "r")
     (write "w")
     (execute "x"))
    (namespace-access
     (owner "full-access")
     (group "read-access")
     (other "no-access"))
    (service-access
     (opencog-admin "full-control")
     (reasoning-user "query-only")
     (guest-user "read-only"))))
```

## Performance Optimizations

### Caching Strategy
```scheme
(define caching-strategy
  '((atom-cache
     (location "/n/atom-cache")
     (policy "LRU")
     (size "256MB"))
    (query-cache
     (location "/n/query-cache")
     (policy "frequency-based")
     (size "128MB"))
    (network-cache
     (location "/n/net-cache")
     (policy "temporal")
     (size "64MB"))))
```

### Load Balancing
```scheme
(define load-balancing
  '((reasoning-distribution
     (strategy "round-robin")
     (nodes '("node1" "node2" "node3"))
     (health-check "/srv/health"))
    (atomspace-sharding
     (strategy "consistent-hashing")
     (partitions 16)
     (replication-factor 3))))
```

## Development Tools

### Build Integration
```scheme
(define build-tools
  '((mk-files
     (atomspace "mkfile.atomspace")
     (cogserver "mkfile.cogserver")
     (reasoning "mkfile.reasoning"))
    (dependencies
     (lib9 "plan9-compat")
     (libbio "buffered-io")
     (libmath "mathematics"))
    (targets
     (libraries ".a files")
     (programs "executable files")
     (tests "test programs"))))
```

### Debugging Support
```scheme
(define debugging-tools
  '((process-debugging
     (ps "/proc/ps")
     (trace "/proc/trace")
     (profile "/proc/profile"))
    (atomspace-debugging
     (dump "/n/atomspace/dump")
     (validate "/n/atomspace/validate")
     (statistics "/n/atomspace/stats"))
    (network-debugging
     (connections "/net/tcp")
     (packets "/net/ether")
     (protocols "/net/log"))))
```

## Benefits of Plan 9 Architecture

1. **Simplicity**: Everything is a file - uniform interface
2. **Composability**: Services combine through standard operations
3. **Distribution**: Network transparency from ground up
4. **Security**: Namespace isolation and authentication
5. **Scalability**: Lightweight processes and message passing
6. **Debugging**: System state visible through file system
7. **Interoperability**: Language-agnostic file-based APIs

This architecture provides a clean, scalable foundation for distributed artificial general intelligence systems, leveraging decades of research in distributed operating systems design.