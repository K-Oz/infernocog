# iyacc: Parser Generator

## Overview

iyacc is Inferno's LALR(1) parser generator, derived from the traditional yacc (Yet Another Compiler Compiler). It generates efficient parsers for context-free grammars, integrating seamlessly with Inferno's development environment and providing enhanced capabilities for cognitive language processing.

## Inferno Base System

### Design Philosophy

iyacc follows Plan 9's tool design principles:
- **Simple Interface**: Clean command-line interface with minimal options
- **Standard Integration**: Works with standard Inferno build tools (mk)
- **Efficient Output**: Generates fast, compact parsers
- **Unicode Support**: Full UTF-8 and rune support for international languages
- **Error Recovery**: Robust error handling and reporting

### Grammar Specification

#### Basic Grammar Format
iyacc grammars use traditional yacc syntax with Inferno-specific enhancements:

```yacc
%{
#include "lib9.h"
#include "parser.h"
%}

%token NUMBER IDENTIFIER
%left '+' '-'
%left '*' '/'
%right UMINUS

%%

expr:
    NUMBER
    | IDENTIFIER  
    | expr '+' expr     { $$ = $1 + $3; }
    | expr '-' expr     { $$ = $1 - $3; }
    | expr '*' expr     { $$ = $1 * $3; }
    | expr '/' expr     { $$ = $1 / $3; }
    | '-' expr %prec UMINUS { $$ = -$2; }
    | '(' expr ')'      { $$ = $2; }
    ;

%%
```

#### Declarations Section
The declarations section (between first `%{` and `%}`) contains:
- C include statements
- Type definitions
- Global variables
- Function prototypes

#### Definitions Section
Between the first `%%` and second `%%`:
- `%token` - Declare terminal symbols
- `%type` - Declare non-terminal types
- `%left`, `%right`, `%nonassoc` - Define operator precedence
- `%start` - Specify start symbol
- `%union` - Define YYSTYPE union

#### Rules Section
Grammar production rules with associated actions:
- Left side: non-terminal symbol
- Right side: sequence of symbols
- Actions: C code in braces `{}`
- Special variables: `$$` (result), `$1`, `$2`, etc. (rule components)

### Advanced Features

#### Precedence and Associativity
```yacc
%left '+' '-'
%left '*' '/' '%'
%right '^'
%right UMINUS

expr: '-' expr %prec UMINUS { $$ = -$2; }
```

#### Semantic Types
```yacc
%union {
    int     ival;
    double  dval;
    char    *sval;
    Rune    *rval;
}

%token <ival> NUMBER
%token <sval> STRING
%token <rval> RUNESTRING
%type <dval> expr
```

#### Error Recovery
```yacc
stmt: expr ';'
    | error ';'     { yyerrok; }
    | error '}'     { yyerrok; }
    ;
```

### Output Files

iyacc generates several files:
- `tab.c` - Main parser implementation
- `tab.h` - Token definitions and declarations
- `y.debug` - Debug information (with `-v` option)
- `y.output` - Parser state information (with `-v` option)

### Integration with Inferno Build System

#### Makefile Integration
```makefile
parser.c parser.h: grammar.y
    iyacc -d grammar.y
    mv tab.c parser.c
    mv tab.h parser.h

compiler: parser.$O lexer.$O main.$O
    $LD -o compiler parser.$O lexer.$O main.$O

parser.$O: parser.c parser.h
    $CC parser.c

%.$O: %.c
    $CC $stem.c
```

#### Unicode and Rune Support
iyacc supports Plan 9's rune-based Unicode processing:

```yacc
%{
#include "lib9.h"

typedef struct {
    Rune *text;
    int len;
} RuneString;
%}

%union {
    Rune *runes;
    RuneString rstring;
}

%token <runes> IDENTIFIER
%type <rstring> string_literal

string_literal: 
    RUNESTRING { 
        $$.text = $1; 
        $$.len = runestrlen($1); 
    }
    ;
```

## InfernoCog AGI Implementation

### Cognitive Grammar Processing

InfernoCog extends iyacc with AGI-aware parsing capabilities for processing cognitive languages and knowledge representations:

#### OpenCog Scheme Parser Generation
```yacc
%{
#include "lib9.h"
#include "cognitive.h"
#include "atomspace.h"
%}

%union {
    Atom        *atom;
    TruthValue  *tv;
    Handle      handle;
    char        *string;
}

%token <atom> CONCEPT_NODE PREDICATE_NODE
%token <tv> TRUTH_VALUE
%token <string> ATOM_NAME
%type <atom> atom_expr
%type <handle> link_expr

%%

atomspace_expr:
    atom_list
    ;

atom_list:
    atom_list atom_expr     { atomspace_add(current_as, $2); }
    | atom_expr             { atomspace_add(current_as, $1); }
    ;

atom_expr:
    '(' CONCEPT_NODE ATOM_NAME ')'
    { 
        $$ = conceptnode_new($3);
        if(current_truth_value)
            atom_set_tv($$, current_truth_value);
    }
    | '(' PREDICATE_NODE ATOM_NAME truth_value ')'
    {
        $$ = predicatenode_new($3);
        atom_set_tv($$, $4);
    }
    ;

truth_value:
    '[' NUMBER NUMBER ']'   { $$ = truthvalue_new($2, $3); }
    | /* empty */           { $$ = truthvalue_default(); }
    ;
```

#### Natural Language Grammar
```yacc
%{
#include "nlp.h"
#include "cognitive.h"
%}

%union {
    NLPNode     *node;
    Concept     *concept;  
    Relation    *relation;
    Sentence    *sentence;
}

%token <node> NOUN VERB ADJECTIVE PREPOSITION
%type <concept> noun_phrase
%type <relation> verb_phrase
%type <sentence> sentence

%%

sentence:
    noun_phrase verb_phrase
    {
        $$ = sentence_create($1, $2);
        cognitive_process_sentence($$);
    }
    ;

noun_phrase:
    ADJECTIVE NOUN
    {
        $$ = concept_modify($2->concept, $1->modifier);
        concept_set_attention($$, attention_focus_current());
    }
    | NOUN
    {
        $$ = $1->concept;
        concept_activate($$);
    }
    ;
```

#### Cognitive Pattern Matching
```yacc
%{
#include "pattern.h"
#include "cognitive.h"
%}

%union {
    Pattern     *pattern;
    Variable    *variable;
    Constraint  *constraint;
    Query       *query;
}

%token VARIABLE CONSTRAINT IMPLIES
%type <pattern> pattern_expr
%type <query> cognitive_query

%%

cognitive_query:
    pattern_expr IMPLIES pattern_expr
    {
        $$ = query_create_implication($1, $3);
        query_set_attention($$, high_attention());
    }
    ;

pattern_expr:
    '(' VARIABLE constraint_list ')'
    {
        $$ = pattern_create($2);
        pattern_add_constraints($$, $3);
    }
    ;
```

### Attention-Aware Parsing

#### Attention-Driven Grammar Selection
```yacc
%{
AttentionValue *current_attention;
GrammarMode current_mode;
%}

%token HIGH_ATTENTION MEDIUM_ATTENTION LOW_ATTENTION

%%

attended_rule:
    HIGH_ATTENTION rule_expr
    {
        set_parse_priority(PRIORITY_HIGH);
        $$ = $2;
        update_attention_history($$);
    }
    | rule_expr  /* default attention */
    {
        $$ = $1;
    }
    ;
```

#### Cognitive Error Recovery
```yacc
cognitive_stmt:
    valid_cognitive_expr
    | error 
    {
        cognitive_error_recovery();
        suggest_correction(yytext);
        yyerrok;
    }
    ;
```

### Distributed Grammar Processing

#### Network-Distributed Parsing
```yacc
%{
#include "distributed.h"

extern CognitiveNetwork *cognet;
%}

%%

distributed_parse:
    complex_expression
    {
        if(expression_complexity($1) > LOCAL_THRESHOLD) {
            $$ = distributed_parse(cognet, $1);
        } else {
            $$ = local_parse($1);
        }
    }
    ;
```

#### Collaborative Grammar Learning
```yacc
%{
#include "learning.h"

GrammarLearner *learner;
%}

%%

learned_rule:
    unknown_pattern
    {
        Pattern *suggestion = grammar_learn(learner, $1);
        if(suggestion) {
            add_dynamic_rule(suggestion);
            $$ = apply_rule(suggestion, $1);
        } else {
            yyerror("Unparseable pattern");
        }
    }
    ;
```

### Advanced Cognitive Features

#### Semantic Memory Integration
```yacc
%{
#include "semantic_memory.h"

SemanticNetwork *sem_net;
%}

%union {
    SemanticConcept *concept;
    SemanticRelation *relation;
}

%%

semantic_statement:
    concept IS_A concept
    {
        semantic_add_isa(sem_net, $1, $3);
        update_concept_strength($1, 0.1);
    }
    | concept HAS_PROPERTY concept
    {
        semantic_add_property(sem_net, $1, $3);
    }
    ;
```

## Examples

### Basic Expression Parser

```yacc
%{
#include "lib9.h"
#include <bio.h>

int yylex(void);
void yyerror(char *s);

double result;
%}

%union {
    double val;
    char *name;
}

%token <val> NUMBER
%token <name> VARIABLE
%left '+' '-'
%left '*' '/'
%right UMINUS
%right '^'

%type <val> expression

%%

input:
    /* empty */
    | input line
    ;

line:
    '\n'
    | expression '\n'   { result = $1; print("= %g\n", $1); }
    | error '\n'        { yyerrok; }
    ;

expression:
    NUMBER              { $$ = $1; }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression 
    {
        if($3 == 0.0)
            yyerror("division by zero");
        else
            $$ = $1 / $3;
    }
    | '-' expression %prec UMINUS { $$ = -$2; }
    | '(' expression ')'          { $$ = $2; }
    ;

%%

void
yyerror(char *s)
{
    fprint(2, "parse error: %s\n", s);
}

int
main(void)
{
    return yyparse();
}
```

### Limbo Language Subset Parser

```yacc
%{
#include "lib9.h"
#include "limbo.h"

extern int yylex(void);
void yyerror(char *s);

Node *program_root;
%}

%union {
    Node *node;
    char *string;
    int ival;
}

%token <string> IDENTIFIER STRING
%token <ival> NUMBER
%token CONST VAR FUNC IF ELSE WHILE FOR
%token IMPLEMENT INCLUDE MODULE

%type <node> program declaration function statement

%%

program:
    declaration_list    { program_root = $1; }
    ;

declaration_list:
    declaration         { $$ = $1; }
    | declaration_list declaration 
    { 
        $$ = node_append($1, $2); 
    }
    ;

declaration:
    VAR IDENTIFIER ':' type ';'
    {
        $$ = node_var_decl($2, $4);
    }
    | FUNC IDENTIFIER '(' parameter_list ')' ':' type block
    {
        $$ = node_func_decl($2, $4, $7, $8);
    }
    ;

statement:
    expression ';'      { $$ = node_expr_stmt($1); }
    | IF '(' expression ')' statement
    {
        $$ = node_if_stmt($3, $5, nil);
    }
    | IF '(' expression ')' statement ELSE statement
    {
        $$ = node_if_stmt($3, $5, $7);
    }
    | block             { $$ = $1; }
    ;

block:
    '{' statement_list '}'  { $$ = node_block($2); }
    ;
```

### InfernoCog Cognitive Language Parser

```yacc
%{
#include "lib9.h"
#include "cognitive.h"
#include "atomspace.h"

AtomSpace *current_atomspace;
AttentionBank *attention_bank;

extern int yylex(void);
void yyerror(char *s);
%}

%union {
    Atom        *atom;
    Handle      handle;
    TruthValue  *tv;
    char        *string;
    double      number;
    CogScript   *script;
}

%token <string> ATOM_NAME VARIABLE_NAME
%token <number> PROBABILITY CONFIDENCE
%token CONCEPT PREDICATE EVALUATION INHERITANCE
%token IMPLICATION AND_LINK OR_LINK NOT_LINK
%token ATTENTION SET_TV QUERY LEARN

%type <atom> atom_expr link_expr
%type <tv> truth_value
%type <script> cognitive_script

%%

cognitive_script:
    statement_list      { $$ = cogscript_create($1); }
    ;

statement_list:
    statement           { $$ = $1; }
    | statement_list statement { $$ = append_statement($1, $2); }
    ;

statement:
    atom_definition ';'     { execute_atom_def($1); }
    | query_statement ';'   { execute_query($1); }
    | attention_statement ';' { execute_attention($1); }
    | learning_statement ';'  { execute_learning($1); }
    ;

atom_definition:
    CONCEPT '(' ATOM_NAME ')' truth_value
    {
        Atom *concept = conceptnode_new($3);
        atom_set_tv(concept, $5);
        $$ = atomspace_add(current_atomspace, concept);
    }
    | INHERITANCE '(' atom_expr ',' atom_expr ')' truth_value
    {
        Atom *inheritance = inheritancelink_new($3, $5);
        atom_set_tv(inheritance, $7);
        $$ = atomspace_add(current_atomspace, inheritance);
    }
    ;

truth_value:
    '[' PROBABILITY CONFIDENCE ']'
    {
        $$ = truthvalue_new($2, $3);
    }
    | /* empty */
    {
        $$ = truthvalue_default();
    }
    ;

query_statement:
    QUERY '(' pattern_expr ')'
    {
        QueryResult *result = pattern_match(current_atomspace, $3);
        $$ = cogstatement_query($3, result);
    }
    ;

attention_statement:
    ATTENTION '(' atom_expr ',' PROBABILITY ')'
    {
        AttentionValue *av = attentionvalue_new($5, 0.0, 0.0);
        atom_set_av($3, av);
        $$ = cogstatement_attention($3, av);
    }
    ;

learning_statement:
    LEARN '(' atom_expr ')'
    {
        cognitive_learn_from_atom($3);
        update_attention_spreading();
        $$ = cogstatement_learn($3);
    }
    ;

%%

void
yyerror(char *s)
{
    fprint(2, "cognitive parse error: %s\n", s);
    cognitive_error_log(s, yylineno);
}

int
main(int argc, char *argv[])
{
    current_atomspace = atomspace_new();
    attention_bank = attentionbank_new();
    
    int result = yyparse();
    
    // Execute cognitive script
    if(result == 0 && program_root) {
        cognitive_execute(program_root);
        attention_update_dynamics();
    }
    
    return result;
}
```

## Command Line Usage

### Basic Usage
```bash
# Generate parser from grammar
iyacc grammar.y

# Generate parser with header file
iyacc -d grammar.y

# Verbose output with debug information
iyacc -v grammar.y

# Custom output filename
iyacc -o myparser.c grammar.y
```

### InfernoCog Extensions
```bash
# Generate cognitive parser
iyacc -cognitive grammar.y

# Enable attention-aware parsing
iyacc -attention grammar.y

# Generate distributed parser
iyacc -distributed grammar.y

# Integrate with AtomSpace
iyacc -atomspace /n/atomspace grammar.y
```

### Integration with mk

```makefile
# Standard parser generation
parser.c parser.h: grammar.y
    iyacc -d grammar.y
    mv tab.c parser.c
    mv tab.h parser.h

# Cognitive parser generation
cognitive_parser.c: cognitive.y
    iyacc -cognitive -d cognitive.y
    mv tab.c cognitive_parser.c
    
# Distributed cognitive parser
distributed_parser.c: distributed.y
    iyacc -distributed -atomspace $ATOMSPACE_PATH distributed.y
    mv tab.c distributed_parser.c
```

## Debugging and Optimization

### Debug Output
```bash
# Generate debug information
iyacc -v grammar.y

# Examine parser states
cat y.output

# Debug parser execution
cc -DYYDEBUG parser.c
./parser -d < input.txt
```

### Performance Optimization
1. **Minimize Grammar Ambiguity**: Reduce shift/reduce conflicts
2. **Optimize Token Design**: Use efficient token recognition
3. **Attention-Based Parsing**: Prioritize important parse paths
4. **Distributed Processing**: Use network resources for complex grammars

### Cognitive Debugging
```bash
# Trace cognitive decisions
iyacc -cognitive-trace grammar.y

# Monitor attention allocation
iyacc -attention-debug grammar.y

# Analyze learning patterns
iyacc -learning-profile grammar.y
```

## See Also

- [mk](mk.md) - Build system integration
- [lib9](lib9.md) - Core library support
- [Yacc Manual](../man/1/yacc) - Traditional yacc documentation
- [Limbo Language](../doc/limbo) - Limbo language specification
- [OpenCog Grammar](https://wiki.opencog.org/w/Grammar) - Cognitive grammar processing
- [LALR Parsing](https://en.wikipedia.org/wiki/LALR_parser) - Parser algorithm details