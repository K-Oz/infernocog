# Plan 9 Scheme Architecture

This document describes the Plan 9 operating system architectural principles and their application in the InfernoCog/OpenCog integration.

## Overview

Plan 9 from Bell Labs represents a clean, distributed computing architecture that influenced Inferno OS design. Key principles include:

- **Everything is a File**: All system resources accessed through file operations
- **9P Protocol**: Network file system protocol for distributed resources
- **Namespaces**: Private, composable views of system resources
- **Process Model**: Lightweight processes with message passing
- **UTF-8 Throughout**: Unicode support at the system level

The loadable Scheme implementation of this architecture lives in [`plan9.scm`](plan9.scm). Inferno's hosted Plan 9 compatibility layer is `lib9` (see [`docs/lib9.md`](docs/lib9.md)); Guix builds it through [`guix.scm`](guix.scm).

## Prerequisites

Before using the Plan 9 architecture with InfernoCog, ensure you have:

- **GNU Guix**: Package manager for reproducible builds
- **Git**: Version control system for source access
- **GCC**: C compiler for `lib9` and hosted Inferno
- **Guile**: Scheme interpreter (≥ 3.0) for `plan9.scm`
- **Inferno tools**: `mk` and `lib9` from this repository (`guix install -f guix.scm`)
- **9P access**: Kernel 9P support or a user-space 9P client for AtomSpace mounts
- **Optional Plan 9 userland**: `9base` or plan9port utilities (`bind`, `mount`, `rc`) when not running native Plan 9

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

## Guix Package Definition

Plan 9 compatibility in InfernoCog is the `lib9` layer of the base package. The following definition matches [`guix.scm`](guix.scm) and [`inferno.scm.md`](inferno.scm.md):

```scheme
(define-public plan9-compat
  (package
    (name "plan9-compat")
    (version "1.0.0")
    (source (local-file "." "inferno-source" #:recursive? #t))
    (build-system gnu-build-system)
    (native-inputs
     `(("lib9" ,(file-append infernocog-base "/lib/lib9.a"))
       ("mk-tool" ,(file-append infernocog-base "/bin/mk"))))
    (synopsis "Plan 9 compatibility layer for InfernoCog")
    (description
     "lib9 provides Plan 9 system-call interfaces, UTF-8/Rune text,
9P conversions, and namespace primitives used by InfernoCog.")
    (home-page "https://github.com/K-Oz/infernocog")
    (license (list gpl2+ lgpl2.1+))))
```

Install the libraries that implement this architecture:

```bash
guix install -f guix.scm
guile -c '(load "plan9.scm") (display (plan9-architecture-ok?)) (newline)'
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

## Usage Examples

### Namespace and 9P

```bash
# Mount CogServer AtomSpace as a 9P file tree
mount -t 9p tcp!localhost!17001 /n/atomspace

# Private working view of atoms
bind /n/atomspace /n/personal-atoms
bind -a /srv/global-atoms /n/personal-atoms

# File-based atom operations
cat /n/atomspace/stats/atom-count
echo "ConceptNode cat" > /n/atomspace/atoms/concept/cat
echo "pattern (Inheritance (Concept cat) (Variable \$x))" > /n/atomspace/queries/ctl
cat /n/atomspace/queries/results
```

### Scheme architecture module

```bash
# Load architecture definitions
guile -l plan9.scm

# Validate the architecture from a script
guile -c '(load "plan9.scm")
         (exit (if (plan9-architecture-ok?) 0 1))'
```

### Distributed nodes

```bash
mount tcp!node1!17001 /n/atoms1
mount tcp!node2!17001 /n/atoms2
echo "reason-batch-1" > /n/atoms1/queries/ctl
echo "reason-batch-2" > /n/atoms2/queries/ctl
```

## Testing

After installing InfernoCog and loading the architecture module:

```bash
# Architecture module loads and validates
guile -c '(load "plan9.scm") (display (plan9-architecture-ok?)) (newline)'

# Integration checks (markdown structure, 9P/AtomSpace concepts)
./test-integration.sh

# lib9 present after a Guix or local build
test -f Linux/386/lib/lib9.a && echo "lib9 ok"
```

Expected `plan9.scm` checks:

- Resource types include `files`, `namespaces`, and `protocols`
- AtomSpace tree is rooted at `/n/atomspace`
- CogServer service announces protocol `9p` on port `17001`

## Development

1. **Set up development environment**:
   ```bash
   guix shell -m manifest.scm
   ```

2. **Edit architecture and documentation together**:
   - Keep alist keys in `plan9.scm` aligned with examples in `plan9.scm.md`
   - Rebuild Plan 9 compatibility: `mk lib9/install`
   - Re-run `./test-integration.sh`

3. **Native Plan 9 hosts** use the `Plan9/` tree (`SYSHOST=Plan9`) instead of `Linux/386`

### Development workflow

```bash
# Load and inspect architecture
guile -c '(load "plan9.scm") (display plan9-resources) (newline)'

# Build the compatibility library
export ROOT=$(pwd) SYSHOST=Linux SYSTARG=Linux OBJTYPE=386
sh makemk.sh
mk lib9/install
```

## Troubleshooting

### Common issues

**`plan9.scm` fails to load**:
- Install Guile ≥ 3.0 (`guix install guile`)
- Run commands from the repository root so the load path finds `plan9.scm`

**9P mount of CogServer fails**:
- Confirm CogServer is listening on port 17001
- Check that the host has 9P (`mount -t 9p`) or a user-space 9P client
- Verify the dial string (`tcp!host!17001`)

**lib9 missing or build errors**:
- Run `sh makemk.sh` before `mk lib9/install`
- On 64-bit Linux, `guix.scm` strips `-m32`; match that if building by hand
- Confirm `mkconfig` has `SYSHOST=Linux` (or `Plan9` on native Plan 9)

**Namespace bind/mount has no effect**:
- Inferno/Plan 9 binds are per-process; they do not change a Unix global namespace
- Use Inferno's `bind`/`mount` inside the emulator, not only host `mount`

**SHA256 or Guix parse errors**:
```bash
guix build --dry-run -f guix.scm
```

## Related Documentation

- [OpenCog Architecture](opencog.scm.md) — cognitive stack and Guix packages
- [Inferno Architecture](inferno.scm.md) — hosted Inferno OS and OpenCog services
- [lib9](docs/lib9.md) — Plan 9 compatibility library API
- [AGI Integration](docs/agi-integration.md) — file-tree mapping for AtomSpace and reasoning

## Benefits of Plan 9 Architecture

1. **Simplicity**: Everything is a file - uniform interface
2. **Composability**: Services combine through standard operations
3. **Distribution**: Network transparency from ground up
4. **Security**: Namespace isolation and authentication
5. **Scalability**: Lightweight processes and message passing
6. **Debugging**: System state visible through file system
7. **Interoperability**: Language-agnostic file-based APIs

This architecture provides a clean, scalable foundation for distributed artificial general intelligence systems, leveraging decades of research in distributed operating systems design.