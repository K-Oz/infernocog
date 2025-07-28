# InfernoCog - Inferno OS with OpenCog Integration

InfernoCog is a distributed operating system based on Inferno®, originally developed at Bell Labs, enhanced with OpenCog cognitive architecture integration. It combines Inferno's distributed computing capabilities with OpenCog's artificial general intelligence framework.

## Overview

Inferno® is a distributed operating system that provides:

- **Distributed Architecture**: Network-transparent resource access via 9P protocol
- **Concurrent Programming**: Limbo language with CSP-style channels  
- **Virtual Machine**: Portable Dis virtual machine for cross-platform execution
- **Unified Resource Model**: Everything accessed as files through a single protocol
- **Per-Process Namespaces**: Customizable resource views for each application

**OpenCog Integration** adds:

- **Cognitive Architecture**: Symbolic reasoning, neural networks, evolutionary programming
- **AtomSpace**: Hypergraph database for knowledge representation
- **Distributed AGI**: OpenCog reasoning distributed across Inferno nodes
- **File-Based Interfaces**: OpenCog atoms and services exposed as Inferno files

## Architecture Integration

InfernoCog integrates OpenCog components with Inferno's distributed architecture:

1. **AtomSpace as File System**: OpenCog atoms exposed through Inferno's file interface
2. **CogServer as 9P Service**: Network access to cognitive services via 9P protocol  
3. **Distributed Reasoning**: OpenCog processes distributed across Inferno network
4. **Unified Security**: Inferno's authentication and namespace isolation protect cognitive data

## Installation

### Via GNU Guix

Install the complete OpenCog stack:

```bash
# Complete cognitive architecture stack
guix install -f opencog.scm

# Or just the Inferno base system
guix install -f guix.scm

# Development environment  
guix shell -m manifest.scm
```

### Manual Installation

```bash
# Clone repository
git clone https://github.com/K-Oz/infernocog.git
cd infernocog

# Install via convenience script
./install.sh
```

## Usage

### Basic Inferno Operations

```bash
# Build essential libraries
mk lib9/install
mk libbio/install  
mk libmath/install

# Use Inferno build system
mk all

# Generate parsers
iyacc grammar.y
```

### OpenCog Integration

```bash
# Mount OpenCog AtomSpace as file system
mount -t 9p cogserver!atomspace /n/atoms

# Query atoms through file operations
cat /n/atoms/concept/animal
echo "ConceptNode cat" > /n/atoms/concept/cat

# Access reasoning services
echo "forward-chain" > /n/reasoning/ctl
cat /n/reasoning/results
```

### Distributed AGI Setup

```bash
# Start CogServer on multiple nodes
cogserverd -p 17001 &  # Node 1
ssh node2 cogserverd -p 17001 &  # Node 2

# Mount distributed AtomSpace
mount tcp!node1!17001 /n/atoms1
mount tcp!node2!17001 /n/atoms2

# Distribute reasoning workload
echo "reason-batch-1" > /n/atoms1/reasoning/queue
echo "reason-batch-2" > /n/atoms2/reasoning/queue
```

## Components

### Inferno Base System
- **lib9**: Plan 9 compatibility library
- **libbio**: Buffered I/O operations
- **libmath**: Mathematical functions
- **mk**: Dependency-driven build tool
- **iyacc**: Parser generator

### OpenCog Stack
- **cogutil**: Foundational utilities (`cogutil@2.0.3-1.b07b41b`)
- **atomspace**: Hypergraph database (`atomspace@5.0.3-1.86c848d`)
- **cogserver**: Network server (`cogserver@0-2.ec5f3b9`)
- **attention**: Attention allocation (`attention@0-1.87d4367`)
- **opencog**: Core reasoning engine (`opencog@0.1.4-1.ceac905`)
- **agi-bio**: Bioinformatics integration (`agi-bio@0-1.b5c6f3d`)

## Architecture Documentation

- [OpenCog Architecture](opencog.scm.md) - OpenCog cognitive architecture details
- [Inferno Architecture](inferno.scm.md) - Inferno OS and integration points
- [Plan 9 Architecture](plan9.scm.md) - Plan 9 design principles and benefits

## Supported Platforms

Inferno can run:

- **Native**: ARM, PowerPC, SPARC, x86 platforms
- **Hosted**: Under existing OS (Linux, FreeBSD, macOS, Plan 9, etc.)

OpenCog integration currently supports:
- **Linux**: Primary development and deployment platform
- **Other Unix-like**: Via hosted Inferno with some limitations

## Development

### Building from Source

```bash
# Set up build environment
export ROOT=$(pwd)
export SYSHOST=Linux
export SYSTARG=Linux
export OBJTYPE=386

# Build mk tool
sh makemk.sh

# Build essential libraries
mk lib9/install
mk libbio/install
mk libmath/install
```

### Development Environment

```bash
# Enter development shell with all dependencies
guix shell -m manifest.scm

# Build and test
mk all
./test-build.sh
./test-integration.sh
```

## License

- **Inferno**: GPL v2+ and LGPL v2.1+
- **OpenCog**: LGPL v2.1+

See [NOTICE](NOTICE) for complete license information.

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes to Scheme files or core system
4. Test with `test-integration.sh`
5. Submit a pull request

## Support

- **InfernoCog Issues**: Use GitHub issues for packaging and integration problems
- **Inferno Questions**: Consult official Inferno documentation
- **OpenCog Questions**: Visit the OpenCog community resources

---

Inferno® is a trademark of Vita Nuova Holdings Ltd.
