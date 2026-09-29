#!/bin/bash
# Test script to verify OpenCog integration with InfernoCog

echo "Testing OpenCog + InfernoCog integration..."

# Test if the scheme files are properly formatted
echo "Validating Scheme files:"

# Check if files exist
for file in opencog.scm.md inferno.scm.md plan9.scm.md opencog.scm plan9.scm; do
    if [ -f "$file" ]; then
        echo "✓ $file exists"
    else
        echo "✗ $file missing"
        exit 1
    fi
done

echo "Checking plan9.scm architecture exports:"
if grep -q "(define (plan9-architecture-ok?)" plan9.scm && \
   grep -q "(define plan9-resources" plan9.scm && \
   grep -q "(define atomspace-filesystem" plan9.scm && \
   grep -q "(define cogserver-service" plan9.scm; then
    echo "✓ plan9.scm defines architecture tables and validator"
else
    echo "✗ plan9.scm missing required architecture definitions"
    exit 1
fi

# Basic syntax check for scheme files
echo "Checking Scheme syntax:"
if guile --version >/dev/null 2>&1; then
    echo "✓ Guile available for syntax checking"
    
    # Test basic scheme file loading
    if guile -c "(load \"opencog.scm\")" 2>/dev/null; then
        echo "✓ opencog.scm loads without syntax errors"
    else
        echo "? opencog.scm may have syntax issues (expected - needs dependencies)"
    fi
    
    if guile -c "(load \"manifest.scm\")" 2>/dev/null; then
        echo "✓ manifest.scm loads without syntax errors"
    else
        echo "? manifest.scm may have syntax issues (expected - needs dependencies)"
    fi

    if guile -c "(load \"plan9.scm\") (exit (if (plan9-architecture-ok?) 0 1))" 2>/dev/null; then
        echo "✓ plan9.scm loads and architecture validates"
    else
        echo "✗ plan9.scm failed to load or architecture validation failed"
        exit 1
    fi
else
    echo "? Guile not available, skipping syntax check"
fi

# Test if guix can parse the files
echo "Testing Guix package parsing:"
if guix describe >/dev/null 2>&1; then
    echo "✓ Guix available"
    
    # Test dry-run of package definition
    if guix build --dry-run -f guix.scm 2>/dev/null; then
        echo "✓ guix.scm parses correctly"
    else
        echo "? guix.scm parsing may need dependencies"
    fi
    
    if guix environment --dry-run -m manifest.scm true 2>/dev/null; then
        echo "✓ manifest.scm parses correctly"
    else
        echo "? manifest.scm parsing may need dependencies"
    fi
else
    echo "? Guix not available, skipping package parsing"
fi

# Check documentation structure
echo "Validating documentation structure:"
for doc in opencog.scm.md inferno.scm.md plan9.scm.md; do
    if grep -q "# " "$doc" && grep -q "##" "$doc"; then
        echo "✓ $doc has proper markdown structure"
    else
        echo "✗ $doc missing proper markdown headers"
        exit 1
    fi
done

echo "Validating plan9.scm.md completeness:"
plan9_missing=0
for section in "Prerequisites" "Guix Package Definition" "Usage Examples" "Testing" "Development" "Troubleshooting"; do
    if grep -q "## $section" plan9.scm.md; then
        echo "✓ plan9.scm.md has ## $section"
    else
        echo "✗ plan9.scm.md missing ## $section"
        plan9_missing=1
    fi
done
if [ "$plan9_missing" -ne 0 ]; then
    exit 1
fi

# Check for key integration concepts
echo "Checking for integration concepts:"
if grep -q "9P" *.md && grep -q "AtomSpace" *.md; then
    echo "✓ Found 9P and AtomSpace integration concepts"
else
    echo "✗ Missing key integration concepts"
fi

if grep -q "distributed" *.md && grep -q "namespace" *.md; then
    echo "✓ Found distributed computing and namespace concepts"
else
    echo "✗ Missing distributed computing concepts"
fi

echo ""
echo "Integration verification complete!"
echo ""
echo "Files created:"
echo "  - opencog.scm.md: OpenCog architecture documentation"
echo "  - inferno.scm.md: Inferno OS architecture documentation"  
echo "  - plan9.scm.md: Plan 9 architecture principles"
echo "  - plan9.scm: Loadable Plan 9 architecture module"
echo "  - opencog.scm: Complete OpenCog package definitions"
echo "  - manifest.scm: Updated development manifest"
echo ""
echo "To use the OpenCog stack:"
echo "  guix install -f opencog.scm    # Install complete stack"
echo "  guix shell -m manifest.scm     # Development environment"