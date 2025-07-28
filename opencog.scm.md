# OpenCog Scheme Architecture

This document describes the OpenCog cognitive architecture integration with InfernoCog (Inferno OS).

## Prerequisites

Before installing the OpenCog stack, ensure you have:

- **GNU Guix**: Package manager for reproducible builds
- **Git**: Version control system for source code access  
- **CMake**: Build system (≥ 3.12)
- **GCC**: C++ compiler with C++17 support
- **Boost**: C++ libraries (≥ 1.65)
- **Python**: Python interpreter (≥ 3.6) for bindings
- **Guile**: Scheme interpreter (≥ 3.0) for scripting

## Overview

OpenCog is an open-source artificial general intelligence (AGI) framework that combines multiple AI paradigms including:

- **Symbolic AI**: Logic-based reasoning and knowledge representation
- **Neural Networks**: Deep learning and pattern recognition  
- **Evolutionary Programming**: Genetic algorithms and program evolution
- **Reinforcement Learning**: Learning through interaction with environment

## Core Components

### 1. CogUtil (`cogutil@2.0.3-1.b07b41b`)

Foundational utilities and data structures for OpenCog:

```scheme
(define-public cogutil
  (package
    (name "cogutil")
    (version "2.0.3-1.b07b41b")
    (source (git-checkout
             (url "https://github.com/opencog/cogutil")
             (commit "b07b41b")))
    (build-system cmake-build-system)
    (synopsis "OpenCog utilities library")
    (description "Foundational utilities and data structures for OpenCog framework")
    (home-page "https://github.com/opencog/cogutil")
    (license lgpl2.1+)))
```

**Note**: The SHA256 hashes in the actual package definitions are currently placeholders (all zeros) and must be updated with correct values for production use.

### 2. AtomSpace (`atomspace@5.0.3-1.86c848d`)

The hypergraph database at the core of OpenCog:

```scheme
(define-public atomspace
  (package
    (name "atomspace")
    (version "5.0.3-1.86c848d")
    (source (git-checkout
             (url "https://github.com/opencog/atomspace")
             (commit "86c848d")))
    (build-system cmake-build-system)
    (inputs `(("cogutil" ,cogutil)))
    (synopsis "OpenCog hypergraph database")
    (description "AtomSpace is a hypergraph database for representing knowledge")
    (home-page "https://github.com/opencog/atomspace")
    (license lgpl2.1+)))
```

### 3. CogServer (`cogserver@0-2.ec5f3b9`)

Network server for AtomSpace access:

```scheme
(define-public cogserver
  (package
    (name "cogserver")
    (version "0-2.ec5f3b9")
    (source (git-checkout
             (url "https://github.com/opencog/cogserver")
             (commit "ec5f3b9")))
    (build-system cmake-build-system)
    (inputs `(("atomspace" ,atomspace)
              ("cogutil" ,cogutil)))
    (synopsis "OpenCog network server")
    (description "Network server providing remote access to AtomSpace")
    (home-page "https://github.com/opencog/cogserver")
    (license lgpl2.1+)))
```

### 4. Attention (`attention@0-1.87d4367`)

Attention allocation mechanisms:

```scheme
(define-public attention
  (package
    (name "attention")
    (version "0-1.87d4367")
    (source (git-checkout
             (url "https://github.com/opencog/attention")
             (commit "87d4367")))
    (build-system cmake-build-system)
    (inputs `(("atomspace" ,atomspace)
              ("cogutil" ,cogutil)))
    (synopsis "OpenCog attention allocation")
    (description "Attention allocation mechanisms for OpenCog")
    (home-page "https://github.com/opencog/attention")
    (license lgpl2.1+)))
```

### 5. OpenCog Core (`opencog@0.1.4-1.ceac905`)

Main OpenCog reasoning engine:

```scheme
(define-public opencog-core
  (package
    (name "opencog")
    (version "0.1.4-1.ceac905")
    (source (git-checkout
             (url "https://github.com/opencog/opencog")
             (commit "ceac905")))
    (build-system cmake-build-system)
    (inputs `(("atomspace" ,atomspace)
              ("cogserver" ,cogserver)
              ("attention" ,attention)
              ("cogutil" ,cogutil)))
    (synopsis "OpenCog AGI framework")
    (description "OpenCog artificial general intelligence framework")
    (home-page "https://github.com/opencog/opencog")
    (license lgpl2.1+)))
```

### 6. AGI-Bio (`agi-bio@0-1.b5c6f3d`)

Bioinformatics and life sciences integration:

```scheme
(define-public agi-bio
  (package
    (name "agi-bio")
    (version "0-1.b5c6f3d")
    (source (git-checkout
             (url "https://github.com/opencog/agi-bio")
             (commit "b5c6f3d")))
    (build-system cmake-build-system)
    (inputs `(("opencog" ,opencog-core)
              ("atomspace" ,atomspace)
              ("cogutil" ,cogutil)))
    (synopsis "OpenCog bioinformatics integration")
    (description "Bioinformatics and life sciences integration for OpenCog")
    (home-page "https://github.com/opencog/agi-bio")
    (license lgpl2.1+)))
```

## Integration with InfernoCog

The OpenCog components integrate with InfernoCog through:

1. **Shared Process Space**: Both systems use Plan 9-style process coordination
2. **Network Services**: CogServer exposes AtomSpace via network protocols compatible with Inferno's 9P
3. **Distributed Computing**: OpenCog reasoning can be distributed across Inferno nodes
4. **Resource Sharing**: Inferno's resource abstraction provides uniform access to OpenCog services

## Architecture Benefits

1. **Distributed AGI**: OpenCog reasoning distributed across Inferno network
2. **Resource Abstraction**: Inferno's everything-is-a-file approach applies to OpenCog data
3. **Concurrent Processing**: Inferno's CSP model enhances OpenCog's parallel processing
4. **Security**: Inferno's security model protects OpenCog knowledge bases
5. **Portability**: OpenCog services can run on any Inferno-supported platform

## Usage Example

```bash
# Install the complete OpenCog stack
guix install cogutil atomspace cogserver attention opencog agi-bio

# Start OpenCog services in Inferno environment
mount -t 9p opencog-server /n/opencog
echo "load-atomspace /data/knowledge.scm" > /n/opencog/ctl
```

## Testing

After installation, verify the OpenCog stack works correctly:

```bash
# Test basic AtomSpace functionality
guile -c "(use-modules (opencog)) (cog-atomspace)"

# Test CogServer connection
telnet localhost 17001

# Run basic pattern matching
echo "(use-modules (opencog)) (cog-evaluate! (Concept \"test\"))" | guile
```

## Development

For developing OpenCog applications on InfernoCog:

1. **Set up development environment**:
   ```bash
   guix shell -m manifest.scm
   ```

2. **Update package versions**:
   - Modify commit hashes in `opencog.scm`
   - Update SHA256 checksums: `guix hash -x <source-dir>`
   - Test changes: `guix build -f opencog.scm`

3. **OpenCog atoms can be exposed as Inferno files**
4. **Reasoning processes run as Inferno services**  
5. **Knowledge bases stored in Inferno file systems**

### Development Workflow

```bash
# Clone and modify OpenCog components
git clone https://github.com/opencog/cogutil
cd cogutil && git log --oneline -n 5  # Get latest commit

# Update opencog.scm with new commit hash
# Rebuild and test
guix build cogutil -f opencog.scm
```

## Troubleshooting

### Common Issues

**Build failures**:
- Ensure all prerequisites are installed
- Check CMake version compatibility (≥ 3.12)
- Verify Boost library version (≥ 1.65)

**Missing dependencies**:
```bash
# Install missing system dependencies
guix install cmake boost python pkg-config
```

**SHA256 mismatch errors**:
```bash
# Update checksums for modified sources
guix hash -x /path/to/opencog/source
```

**CogServer connection issues**:
- Verify port 17001 is available
- Check firewall settings
- Ensure AtomSpace is properly initialized

This architecture provides a robust foundation for distributed artificial general intelligence systems.