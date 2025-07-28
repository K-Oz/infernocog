# InfernoCog - GNU Guix Package

This repository provides the Inferno distributed operating system packaged for GNU Guix as "opencog".

## About Inferno

Inferno is a distributed operating system originally developed at Bell Labs. It provides:

- A concurrent programming environment with the Limbo language
- A portable virtual machine (Dis)  
- A unified file-based interface for all system resources
- The 9P network protocol for distributed services

## Installation via GNU Guix

### Prerequisites

- GNU Guix package manager installed
- A GNU/Linux system

### Install from this repository

1. Clone this repository:
   ```bash
   git clone https://github.com/K-Oz/infernocog.git
   cd infernocog
   ```

2. Install using Guix:
   ```bash
   guix install -f guix.scm
   ```

   Or use the convenience script:
   ```bash
   ./install.sh
   ```

### Install from Guix channels (future)

Once this package is submitted to the Guix package collection, you will be able to install it with:

```bash
guix install opencog
```

## What's Included

The package includes:

- Essential Inferno libraries (lib9, libbio, libmath, libmp, libsec)
- The `mk` build tool (Inferno's make system)
- The `iyacc` parser generator
- Header files for Inferno development
- Documentation

## Development Environment

For development with Inferno, you can create a development environment:

```bash
guix shell -m manifest.scm
```

This will provide all the dependencies needed for building Inferno applications.

## Usage

After installation, the following tools are available:

- `mk` - Inferno's build system (similar to make)
- `iyacc` - Parser generator for Limbo

## Limitations

This package provides the essential Inferno libraries and tools but does not include:

- The complete Limbo compiler (due to compatibility issues with 64-bit systems)
- The full Inferno runtime environment
- Graphical applications

These limitations may be addressed in future versions.

## License

Inferno is available under the GPL and LGPL licenses. See the NOTICE file for details.

## Contributing

To contribute to this Guix package:

1. Fork this repository
2. Make your changes to `guix.scm` or `manifest.scm`
3. Test the package installation
4. Submit a pull request

## Support

For issues specific to the Guix packaging, please open an issue in this repository.

For general Inferno questions, consult the official Inferno documentation.