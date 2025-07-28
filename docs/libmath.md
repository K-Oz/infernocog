# libmath: Mathematical Functions

## Overview

libmath provides comprehensive mathematical functionality for Inferno applications, including floating-point operations, linear algebra, and numerical computation. It combines the fdlibm (Freely Distributable LIBM) mathematical library with BLAS operations and platform-specific floating-point control, enhanced for cognitive computing requirements.

## Inferno Base System

### Design Philosophy

libmath follows Plan 9's mathematical computing principles:
- **Portable Precision**: Consistent floating-point behavior across platforms
- **IEEE 754 Compliance**: Standard floating-point arithmetic semantics
- **Minimal Dependencies**: Self-contained mathematical functions
- **Performance Oriented**: Optimized for common mathematical operations

### Core Components

#### FDLIBM Mathematical Functions
Complete implementation of standard mathematical functions:

```c
// Trigonometric functions
double sin(double x);
double cos(double x);
double tan(double x);
double asin(double x);
double acos(double x);
double atan(double x);
double atan2(double y, double x);

// Hyperbolic functions  
double sinh(double x);
double cosh(double x);
double tanh(double x);
double asinh(double x);
double acosh(double x);
double atanh(double x);

// Exponential and logarithmic functions
double exp(double x);
double log(double x);
double log10(double x);
double pow(double x, double y);
double sqrt(double x);
```

#### Floating-Point Control
Platform-specific floating-point environment management:

```c
// Floating-point control functions
void    FPinit(void);               // Initialize FP environment
ulong   getFPstatus(void);          // Get FP status register
ulong   FPstatus(ulong fsr, ulong mask);  // Set FP status
ulong   getFPcontrol(void);         // Get FP control register
ulong   FPcontrol(ulong fcr, ulong mask); // Set FP control

// FP status flags
#define INEX    0x01    // Inexact result
#define UNFL    0x02    // Underflow
#define OVFL    0x04    // Overflow  
#define ZDIV    0x08    // Division by zero
#define INVAL   0x10    // Invalid operation
```

#### BLAS Operations
Basic Linear Algebra Subprograms for efficient vector and matrix operations:

```c
// Level 1 BLAS (vector operations)
double  dot(int n, double *x, double *y);        // Dot product
void    axpy(int n, double a, double *x, double *y); // y = a*x + y
double  norm(int n, double *x);                  // Euclidean norm
int     iamax(int n, double *x);                 // Index of max element

// Level 2 BLAS (matrix-vector operations)  
void    gemv(int m, int n, double alpha, double *a, double *x, 
             double beta, double *y);            // y = alpha*A*x + beta*y

// Level 3 BLAS (matrix-matrix operations)
void    gemm(int m, int n, int k, double alpha, double *a, double *b,
             double beta, double *c);            // C = alpha*A*B + beta*C
```

#### Numerical Utilities
```c
// Utility functions
double  pow10(int n);               // Power of 10
double  fdim(double x, double y);   // Positive difference
int     isnan(double x);            // Test for NaN
int     isinf(double x);            // Test for infinity
double  copysign(double x, double y); // Copy sign
```

### Platform Portability

libmath provides platform-specific optimizations while maintaining API consistency:

- **Linux**: Optimized for x86, ARM, and PowerPC architectures
- **Windows**: Native Win32 floating-point support
- **macOS**: Darwin-specific optimizations
- **FreeBSD/OpenBSD/NetBSD**: BSD floating-point environments
- **Solaris**: SPARC and x86 implementations
- **AIX**: PowerPC optimizations

Each platform implements optimal floating-point control and exception handling.

### Precision and Error Handling

#### IEEE 754 Compliance
- **Double Precision**: Primary floating-point type (64-bit)
- **Exception Handling**: Configurable floating-point exceptions
- **Special Values**: Proper handling of NaN, infinity, and denormals
- **Rounding Modes**: Support for all IEEE rounding modes

#### Error Reporting
```c
// Error detection
if(isnan(result)) {
    // Handle NaN result
}
if(isinf(result)) {  
    // Handle infinite result
}
```

## InfernoCog AGI Implementation

### Cognitive Mathematical Extensions

InfernoCog enhances libmath with AGI-specific mathematical operations optimized for cognitive computing:

#### Truth Value Mathematics
```c
// Truth value operations for probabilistic reasoning
typedef struct TruthValue TruthValue;
struct TruthValue {
    double strength;    // Probability estimate [0,1]
    double confidence;  // Confidence in estimate [0,1]  
};

// Truth value arithmetic
TruthValue tv_and(TruthValue a, TruthValue b);
TruthValue tv_or(TruthValue a, TruthValue b);
TruthValue tv_not(TruthValue a);
TruthValue tv_implication(TruthValue premise, TruthValue conclusion);
double     tv_entropy(TruthValue tv);
```

#### Fuzzy Logic Operations
```c
// Fuzzy set operations
double  fuzzy_and(double a, double b);         // Minimum t-norm
double  fuzzy_or(double a, double b);          // Maximum t-conorm  
double  fuzzy_not(double a);                  // Standard negation
double  fuzzy_implication(double a, double b); // Lukasiewicz implication

// Fuzzy aggregation
double  fuzzy_mean(int n, double *values, double *weights);
double  fuzzy_weighted_sum(int n, double *values, double *weights);
```

#### Attention Value Mathematics
```c
// Attention value computations for cognitive focus
typedef struct AttentionValue AttentionValue;
struct AttentionValue {
    double sti;     // Short-term importance
    double lti;     // Long-term importance  
    double vlti;    // Very long-term importance
};

// Attention dynamics
AttentionValue av_decay(AttentionValue av, double rate);
AttentionValue av_stimulate(AttentionValue av, double amount);
double         av_rent(AttentionValue av);    // Attention rent calculation
```

#### Statistical Learning Functions
```c
// Bayesian inference support
double  bayes_update(double prior, double likelihood, double evidence);
double  beta_function(double alpha, double beta);
double  gamma_function(double x);
double  digamma(double x);                    // Derivative of log gamma

// Information theory
double  entropy(int n, double *probs);
double  mutual_information(int n, double *joint, double *marginal_x, double *marginal_y);
double  kl_divergence(int n, double *p, double *q);
```

### Cognitive Linear Algebra

#### Hypergraph Mathematics
```c
// Hypergraph operations for cognitive structures
typedef struct CogMatrix CogMatrix;
struct CogMatrix {
    int     rows, cols;
    double  *data;
    int     cognitive_type;  // Matrix semantic type
};

// Cognitive matrix operations
CogMatrix* cogmat_create(int rows, int cols, int type);
CogMatrix* cogmat_multiply(CogMatrix *a, CogMatrix *b);
double     cogmat_trace(CogMatrix *m);        // Trace for attention flow
void       cogmat_normalize(CogMatrix *m);    // Stochastic normalization
```

#### Pattern Recognition Mathematics
```c
// Pattern matching and similarity
double  cosine_similarity(int n, double *a, double *b);
double  euclidean_distance(int n, double *a, double *b);
double  jaccard_index(int n, int *set_a, int *set_b);
double  edit_distance(char *str1, char *str2);

// Clustering and classification
void    kmeans(int n, int k, double *points, double *centroids, int *clusters);
double  silhouette_score(int n, int k, double *points, int *clusters);
```

#### Neural Network Mathematics
```c
// Activation functions for neural processing
double  sigmoid(double x);
double  sigmoid_derivative(double x);
double  relu(double x);
double  relu_derivative(double x);
double  tanh_activation(double x);
double  softmax(int n, double *inputs, double *outputs);

// Loss functions
double  mse_loss(int n, double *predicted, double *actual);
double  cross_entropy_loss(int n, double *predicted, double *actual);
```

### Distributed Mathematical Computing

#### Parallel Matrix Operations
```c
// Multi-threaded mathematical operations
typedef struct MathPool MathPool;
MathPool* mathpool_create(int nthreads);
void      mathpool_gemm(MathPool *pool, int m, int n, int k, 
                       double *a, double *b, double *c);
void      mathpool_destroy(MathPool *pool);
```

#### Network-Distributed Computation
```c
// Distributed mathematical computation across Inferno nodes
typedef struct DistMath DistMath;
DistMath* distmath_connect(char *netaddr);
double*   distmath_compute(DistMath *dm, char *operation, 
                          double *inputs, int ninputs);
void      distmath_close(DistMath *dm);
```

### Cognitive Optimization

#### Attention-Guided Computation
```c
// Mathematical operations prioritized by attention values
double  attention_weighted_sum(int n, double *values, AttentionValue *attention);
void    attention_sort(int n, double *values, AttentionValue *attention);
int     attention_threshold(int n, AttentionValue *attention, double threshold);
```

Mathematical operations can be prioritized based on attention allocation, improving cognitive efficiency.

## Examples

### Basic Mathematical Operations

```c
#include "lib9.h"
#include "mathi.h"

void
trigonometry_example(void)
{
    double angle = 3.14159 / 4;  // 45 degrees
    double sin_val, cos_val, tan_val;
    
    // Initialize floating-point environment
    FPinit();
    
    sin_val = sin(angle);
    cos_val = cos(angle);
    tan_val = tan(angle);
    
    print("sin(π/4) = %g\n", sin_val);
    print("cos(π/4) = %g\n", cos_val);  
    print("tan(π/4) = %g\n", tan_val);
}
```

### Linear Algebra Operations

```c
void
matrix_multiply_example(void)
{
    double a[] = {1.0, 2.0, 3.0, 4.0};    // 2x2 matrix
    double b[] = {5.0, 6.0, 7.0, 8.0};    // 2x2 matrix
    double c[] = {0.0, 0.0, 0.0, 0.0};    // Result matrix
    
    // C = A * B using BLAS GEMM
    gemm(2, 2, 2, 1.0, a, b, 0.0, c);
    
    print("Result matrix:\n");
    print("[%g %g]\n", c[0], c[1]);
    print("[%g %g]\n", c[2], c[3]);
}
```

### InfernoCog Truth Value Operations

```c
#include "lib9.h"
#include "mathi.h"
#include "cognitive.h"

void
truth_value_reasoning(void)
{
    TruthValue premise = {0.8, 0.9};     // High confidence premise
    TruthValue conclusion = {0.6, 0.7};  // Moderate confidence conclusion
    TruthValue implication;
    
    // Compute implication truth value
    implication = tv_implication(premise, conclusion);
    
    print("Premise: strength=%g, confidence=%g\n", 
          premise.strength, premise.confidence);
    print("Conclusion: strength=%g, confidence=%g\n",
          conclusion.strength, conclusion.confidence);
    print("Implication: strength=%g, confidence=%g\n",
          implication.strength, implication.confidence);
    
    // Calculate entropy for information content
    double entropy_val = tv_entropy(implication);
    print("Information entropy: %g bits\n", entropy_val);
}
```

### Attention-Weighted Computation

```c
void
attention_computation_example(void)
{
    double values[] = {10.0, 20.0, 30.0, 40.0};
    AttentionValue attention[] = {
        {0.9, 0.5, 0.1},  // High short-term importance
        {0.3, 0.8, 0.9},  // High long-term importance  
        {0.1, 0.1, 0.1},  // Low importance
        {0.7, 0.6, 0.4}   // Moderate importance
    };
    
    // Compute attention-weighted sum
    double result = attention_weighted_sum(4, values, attention);
    print("Attention-weighted sum: %g\n", result);
    
    // Sort by attention priority  
    attention_sort(4, values, attention);
    print("Attention-sorted values:\n");
    for(int i = 0; i < 4; i++) {
        print("  %g (STI: %g)\n", values[i], attention[i].sti);
    }
}
```

### Distributed Mathematical Computing

```c
void
distributed_computation_example(void)
{
    DistMath *dm;
    double inputs[] = {1.0, 2.0, 3.0, 4.0, 5.0};
    double *results;
    
    // Connect to distributed math service
    dm = distmath_connect("tcp!cognitive-node!17003");
    if(dm == nil)
        sysfatal("cannot connect to math service");
        
    // Compute distributed FFT
    results = distmath_compute(dm, "fft", inputs, 5);
    if(results != nil) {
        print("FFT results:\n");
        for(int i = 0; i < 5; i++) {
            print("  %g\n", results[i]);
        }
        free(results);
    }
    
    distmath_close(dm);
}
```

## Performance Considerations

### Numerical Stability
- Use `fdim()` for differences that might underflow
- Check for NaN and infinity in intermediate results
- Use stable algorithms for matrix decomposition
- Apply proper scaling for very large or small numbers

### Cognitive Computing Optimization
- Cache frequently accessed truth values
- Use attention values to prioritize expensive computations
- Batch matrix operations for better cache utilization
- Distribute large cognitive computations across network

### Platform-Specific Performance
- Enable platform-specific floating-point optimizations
- Use vectorized operations where available
- Consider SIMD instructions for parallel mathematical operations
- Optimize memory access patterns for cache efficiency

## See Also

- [lib9](lib9.md) - Core Plan 9 compatibility library
- [libbio](libbio.md) - Buffered I/O operations
- [mk](mk.md) - Build system integration
- [FDLIBM Documentation](../libmath/fdlibm/readme) - Mathematical library details
- [OpenCog Math](https://wiki.opencog.org/w/TruthValue) - Truth value mathematics
- [BLAS Reference](http://www.netlib.org/blas/) - Linear algebra specifications