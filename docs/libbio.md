# libbio: Buffered I/O Operations

## Overview

libbio provides efficient buffered I/O operations for Inferno applications, implementing the Plan 9 Bio interface. It offers high-performance file and network I/O with automatic buffering, UTF-8 support, and network transparency essential for distributed computing environments.

## Inferno Base System

### Design Philosophy

libbio follows Plan 9's I/O philosophy:
- **Unified Interface**: Same API for files, pipes, and network connections
- **Automatic Buffering**: Transparent performance optimization
- **UTF-8 Native**: Full Unicode support in all operations
- **Network Transparent**: Seamless operation across 9P protocol

### Core Architecture

#### Biobuf Structure
The central `Biobuf` structure manages buffered I/O state:

```c
typedef struct Biobuf Biobuf;
struct Biobuf {
    int     icount;     // input count
    int     ocount;     // output count  
    int     rdline;     // read line delimiter
    int     runesize;   // UTF-8 rune buffer size
    int     state;      // buffer state flags
    int     fid;        // file descriptor
    int     flag;       // operation flags
    vlong   offset;     // current file offset
    char    *beg;       // buffer beginning
    char    *ebuf;      // buffer end
    char    *gbuf;      // get buffer pointer
    char    *bbuf;      // base buffer
};
```

#### Buffer States
- `Bractive` - Active read buffer
- `Bwactive` - Active write buffer  
- `Binactive` - Inactive buffer
- `Beof` - End of file reached
- `Berror` - Error state

### Core Functions

#### Initialization and Cleanup
```c
Biobuf* Binit(Biobuf *bp, int fd, int mode);
int     Bterm(Biobuf *bp);
int     Bflush(Biobuf *bp);
```

#### Reading Operations
```c
int     Bgetc(Biobuf *bp);              // Read single character
Rune    Bgetrune(Biobuf *bp);           // Read UTF-8 rune
long    Bread(Biobuf *bp, void *buf, long n);  // Read n bytes
char*   Brdline(Biobuf *bp, int delim); // Read line until delimiter
char*   Brdstr(Biobuf *bp, int delim, int nulldelim); // Read string
```

#### Writing Operations  
```c
int     Bputc(Biobuf *bp, int c);       // Write character
int     Bputrune(Biobuf *bp, Rune r);   // Write UTF-8 rune  
long    Bwrite(Biobuf *bp, void *buf, long n); // Write n bytes
int     Bprint(Biobuf *bp, char *fmt, ...);    // Formatted output
int     Bvprint(Biobuf *bp, char *fmt, va_list arg); // Varargs print
```

#### Position Control
```c
vlong   Bseek(Biobuf *bp, vlong offset, int whence);
vlong   Boffset(Biobuf *bp);
int     Bbuffered(Biobuf *bp);
```

### Buffer Management

#### Automatic Buffering
libbio automatically manages buffer allocation and sizing:
- **Read Buffering**: Prefetches data to minimize system calls
- **Write Buffering**: Accumulates output for efficient writes  
- **Dynamic Sizing**: Buffer size adapts to I/O patterns
- **Memory Efficiency**: Minimal memory overhead per buffer

#### Line-Oriented I/O
Specialized support for text processing:
- **Line Reading**: Efficient line-by-line processing
- **Delimiter Control**: Configurable line endings
- **UTF-8 Awareness**: Proper handling of multi-byte characters

### Network Integration

libbio seamlessly works with Inferno's 9P protocol:
- **9P Streams**: Direct buffering of 9P file operations
- **Network Files**: Transparent buffering of remote files
- **Connection Pooling**: Reuse of network connections
- **Error Recovery**: Graceful handling of network interruptions

## InfernoCog AGI Implementation

### Cognitive Stream Processing

InfernoCog extends libbio with AGI-aware streaming capabilities for processing cognitive data structures:

#### AtomSpace Streaming
```c
// AGI-specific Biobuf extensions
typedef struct CogBuf CogBuf;
struct CogBuf {
    Biobuf  *bio;           // Base bio buffer
    AtomSpace *atomspace;   // Associated AtomSpace
    int     atomfmt;        // Atom serialization format
    ulong   cogflags;       // Cognitive processing flags
};

// Cognitive streaming functions
CogBuf* Coginit(int fd, int mode, AtomSpace *as);
Atom*   Cgetratom(CogBuf *cb);           // Read serialized atom
int     Cputatom(CogBuf *cb, Atom *atom); // Write serialized atom
Handle  Cgethandle(CogBuf *cb);          // Read atom handle
```

#### Hypergraph Serialization
Efficient I/O for large cognitive structures:

```c
// Hypergraph streaming
int     Cputgraph(CogBuf *cb, HandleSeq *handles);
HandleSeq* Cgetgraph(CogBuf *cb);
int     Cputtruth(CogBuf *cb, TruthValue *tv);
TruthValue* Cgettruth(CogBuf *cb);
```

#### Cognitive Data Formats

InfernoCog supports multiple serialization formats:

1. **Binary Format**: Compact binary representation
2. **S-Expression**: Lisp-style textual format
3. **JSON**: Web-compatible representation
4. **MessagePack**: High-performance binary format

```c
// Format selection
#define COGFMT_BINARY   0x01
#define COGFMT_SEXPR    0x02  
#define COGFMT_JSON     0x04
#define COGFMT_MSGPACK  0x08

int Csetformat(CogBuf *cb, int format);
```

### Distributed Cognitive I/O

#### Remote AtomSpace Access
```c
// Connect to remote cognitive nodes
CogBuf* Cogdial(char *netaddr, char *atomspace);
int     Cogping(CogBuf *cb);  // Test connection liveness
void    Coghup(CogBuf *cb);   // Close cognitive connection
```

#### Streaming Inference
```c
// Stream-based reasoning operations  
int     Cstartinfer(CogBuf *cb, char *rule);
Atom*   Cgetnext(CogBuf *cb);     // Get next inferred atom
int     Cinfereof(CogBuf *cb);    // Check if inference complete
```

#### Cognitive Event Streams
```c
// Real-time cognitive event processing
typedef struct CogEvent CogEvent;
struct CogEvent {
    int     type;       // Event type (add, remove, update)
    Atom    *atom;      // Affected atom
    TruthValue *oldtv;  // Previous truth value
    TruthValue *newtv;  // New truth value
    ulong   timestamp;  // Event timestamp
};

int     Cputevent(CogBuf *cb, CogEvent *event);
CogEvent* Cgetevent(CogBuf *cb);
```

### Performance Optimizations

#### Cognitive Buffer Tuning
```c
// Cognitive-specific buffer optimization
int     Csetbufsize(CogBuf *cb, int size);
int     Csetatomcache(CogBuf *cb, int maxatoms);
void    Cflushcache(CogBuf *cb);
```

#### Parallel Processing
```c
// Multi-threaded cognitive I/O
typedef struct CogPool CogPool;
CogPool* Cogpoolcreate(int nthreads);
int     Cogpoolread(CogPool *pool, CogBuf *cb, Atom **atoms, int n);
int     Cogpoolwrite(CogPool *pool, CogBuf *cb, Atom **atoms, int n);
void    Cogpooldestroy(CogPool *pool);
```

### Integration with Attention Allocation

InfernoCog libbio integrates with OpenCog's attention mechanism:

```c
// Attention-aware I/O prioritization
int     Csetpriority(CogBuf *cb, float priority);
int     Cgetpriority(CogBuf *cb);
void    Cattentionfocus(CogBuf *cb, HandleSeq *focus);
```

High-attention atoms receive I/O priority, improving response time for important cognitive operations.

## Examples

### Basic File I/O

```c
#include "lib9.h"
#include <bio.h>

void
copy_file(char *src, char *dst)
{
    Biobuf bin, bout;
    int c;
    
    if(Binit(&bin, open(src, OREAD), OREAD) < 0)
        sysfatal("cannot open %s", src);
    if(Binit(&bout, create(dst, OWRITE, 0644), OWRITE) < 0)
        sysfatal("cannot create %s", dst);
        
    while((c = Bgetc(&bin)) >= 0)
        Bputc(&bout, c);
        
    Bterm(&bin);
    Bterm(&bout);
}
```

### Line Processing

```c
void
process_lines(char *filename)
{
    Biobuf *bp;
    char *line;
    
    bp = Bopen(filename, OREAD);
    if(bp == nil)
        sysfatal("cannot open %s", filename);
        
    while((line = Brdline(bp, '\n')) != nil) {
        // Remove newline
        line[Blinelen(bp)-1] = '\0';
        print("Line: %s\n", line);
    }
    
    Bterm(bp);
}
```

### InfernoCog Cognitive Data Processing

```c
#include "lib9.h"
#include <bio.h>
#include "cognitive.h"

void
export_atomspace(AtomSpace *as, char *filename)
{
    CogBuf *cb;
    HandleSeq handles;
    Handle h;
    int i;
    
    cb = Coginit(create(filename, OWRITE, 0644), OWRITE, as);
    if(cb == nil)
        sysfatal("cannot create cognitive buffer");
        
    // Set binary format for efficiency
    Csetformat(cb, COGFMT_BINARY);
    
    // Export all atoms
    handles = as->get_all_atoms();
    for(i = 0; i < handles.size(); i++) {
        h = handles[i];
        Cputatom(cb, as->get_atom(h));
    }
    
    Cogterm(cb);
}

void
import_atomspace(AtomSpace *as, char *filename) 
{
    CogBuf *cb;
    Atom *atom;
    
    cb = Coginit(open(filename, OREAD), OREAD, as);
    if(cb == nil)
        sysfatal("cannot open %s", filename);
        
    while((atom = Cgetratom(cb)) != nil) {
        as->add_atom(atom);
    }
    
    Cogterm(cb);
}
```

### Distributed Cognitive Processing

```c
void
stream_reasoning(char *remote_node)
{
    CogBuf *cb;
    Atom *result;
    
    // Connect to remote reasoning node
    cb = Cogdial(remote_node, "reasoning_atomspace");
    if(cb == nil)
        sysfatal("cannot connect to %s", remote_node);
        
    // Start inference stream
    if(Cstartinfer(cb, "forward-chaining") < 0)
        sysfatal("inference failed");
        
    // Process results as they arrive
    while(!Cinfereof(cb)) {
        result = Cgetnext(cb);
        if(result != nil) {
            print("Inferred: %A\n", result);
        }
    }
    
    Coghup(cb);
}
```

## Performance Considerations

### Buffer Sizing
- **Small Files**: 4KB buffers minimize memory usage
- **Large Files**: 64KB+ buffers improve throughput
- **Network I/O**: 16KB buffers balance latency and bandwidth
- **Cognitive Data**: Size based on average atom complexity

### Memory Management
- Always call `Bterm()` or `Bflush()` to ensure data persistence
- Use `Bbuffered()` to check pending data before closing
- For cognitive data, monitor AtomSpace memory usage during I/O

### Network Optimization
- Use `Bprint()` instead of multiple `Bputc()` calls
- Batch cognitive operations with `Cputgraph()`
- Enable compression for large cognitive datasets

## See Also

- [lib9](lib9.md) - Core Plan 9 compatibility library
- [libmath](libmath.md) - Mathematical functions
- [mk](mk.md) - Build system integration
- [Bio Manual](../man/2/bio) - Traditional bio interface documentation
- [OpenCog Serialization](https://wiki.opencog.org/w/Serialization) - Cognitive data formats