/**
 *	\file "lexer/spice-lex.ll"
 *	vi: ft=lex
 *	Will generate .cc (C++) file for the token-scanner.  
 *	$Id: spice-lex.ll,v 1.9 2011/02/10 22:32:38 fang Exp $
 */

/****** DEFINITIONS **********************************************************/

%{
/* scanner-specific header */

#define	ENABLE_STATIC_TRACE			0
#define	ENABLE_STACKTRACE			(0 && !defined(LIBBOGUS))

#include <iostream>
#include <cstdlib>
#include <iomanip>
#include "util/sstream.hh"

#if 0
#ifdef	LIBBOGUS
#define	__LEXYACC_SPICE__PREFIX_H__
// prevents renaming
#endif
#endif

#include "util/macros.h"
#include "util/using_ostream.hh"
#include "parser/spice-prefix.h"
#include "util/stacktrace.hh"
#include "util/syntax.hh"		/* everything needed for "y.tab.h" */
using namespace util::syntax;

// DIRTY MAKE HACK ALERT
#if	defined(LIBBOGUS)
#include "parser/spice-parse.hh"		/* symbols generated by yacc */
#else
#include "parser/spice-parse-real.hh"	/* symbols generated by yacc */
#endif
// END DIRTY HACK ALERT

#include "lexer/hac_lex.hh"
#include "lexer/spice-lex-options.h"
#include "lexer/flex_lexer_state.hh"
#include "lexer/input_manager.hh"
#include "lexer/file_manager.hh"
using flex::lexer_state;

/**
	If lexyacc_test links against main parser, 
	we will want to avoid a symbol conflict.
 */
#if	defined(LIBBOGUS)
#define	spice_parse_file_manager	yy_parse_file_manager
#define	spice_embedded_file_stack	yy_embedded_file_stack
#endif
/**
	This is the file stack and include path manager for 
	the spice parser.  
	This is globally visible and accessible (unfortunately).  
 */
HAC::lexer::file_manager
spice_parse_file_manager;

/**
	Auxiliary stack for file-embedding construct, whereby the
	lexer pushes a fake file onto this stack, and the parser
	pops it off the stack when the file construct is reduced.  
 */
HAC::lexer::embedded_file_stack_type
spice_embedded_file_stack;


/// generated in "parser/spice-union.cc" for deleting tokens
extern
void
yy_union_lookup_delete(const YYSTYPE&, const int);

extern
std::ostream&
yy_union_lookup_dump(const YYSTYPE&, const int, std::ostream&);


namespace HAC {

namespace lexer {

/**
	Maximum string length.  Can be extended arbitrarily.  
 */
#define	STRING_MAX_LEN		1024

static token_position	CURRENT(1,0,1);

/**
	Thie macro is intended for use with ostream& operator << .
	\param c is a token_position.  
 */
#define	LINE_COL(c)	"on line " << c.line << ":" << c.col

/* debugging switches -- consider making these macro-defined */
static const int token_feedback = 0;

/**
	Debugging tool.  
	This will generate excessive feedback for every detailed
	action of the lexer, even in the middle of tokenizing.  
 */
static inline void
DEFAULT_TOKEN_FEEDBACK(const lexer_state& foo) {
	if (token_feedback) {
		cerr << "token = " << yytext <<
			" " LINE_COL(CURRENT) << endl;
	}
}

/* macros for tracking single line tokens (no new line) */

static inline void
TOKEN_UPDATE(const lexer_state& foo) {
	DEFAULT_TOKEN_FEEDBACK(foo);
	CURRENT.col += yyleng;
}

static inline void
KEYWORD_UPDATE(YYSTYPE& spice_lval, const lexer_state& foo) {
	spice_lval._void = NULL;
#if ENABLE_STACKTRACE
	STACKTRACE_INDENT_PRINT("new keyword: " << yytext << endl);
#endif
	TOKEN_UPDATE(foo);
}

static inline void
NEWLINE_UPDATE(const lexer_state& foo) {
	CURRENT.line++; CURRENT.col = 1;
#if 0
	cerr << "Line number advanced to " << CURRENT.line << endl;
#endif
}

static inline void
NODE_POSITION_UPDATE(YYSTYPE& lval, const lexer_state& foo) {
//	lval._node_position = new node_position(yytext, CURRENT);
	TOKEN_UPDATE(foo);
}

}	/* end namespace lexer */
}	/* end namespace HAC */

using namespace HAC::lexer;

%}

DIGIT		[0-9]
/**
HEXDIGIT	[0-9A-Fa-f]
IDHEAD		[a-zA-Z_]
IDBODY		[a-zA-Z0-9_]
**/
SPICE_IDCHAR	[^ \t\n=,()\\]
INT		{DIGIT}+
SIGN_INT	[+-]?{INT}
/**
TODO: scientific unit suffixes
**/
EXP		[eE]{SIGN_INT}
FRACTIONAL	"."{INT}
FLOAT		({INT}{FRACTIONAL}{EXP}?)|({INT}{FRACTIONAL}?{EXP})
NUM		{INT}|{FLOAT}
NUMSCI		{NUM}[gGkKmMuUnNpPfFaA]?

/* note: '-' signed ints are lexed as two tokens and combined in the parser
	as a unary expr, thus, no numerical tokens in the language 
	*start* with a sign.  
	A sign in the exponent of a floating-point number is acceptable.  
*/

SPICE_ID	{SPICE_IDCHAR}+
ESCAPEDID	"\\"[^ \t\n]+
/**
BADID		{INT}{ID}
**/
WHITESPACE	[ \t]+
NEWLINE		"\n"
WS		{WHITESPACE}

POSITIONTOKEN	[=,()]

CONNECT		"\.connect"|"\.CONNECT"
SUBCKT		"\.subckt"|"\.SUBCKT"
ENDS		"\.ends"|"\.ENDS"
END		"\.end"|"\.END"
/* omit flow control statements */

/* these cards have been replaced using the lib/scripts/hacspice-pp.sed */
RES		"\.resistor"
CAP		"\.capacitor"
IND		"\.inductor"
DEV		"\.mosfet"
INST		"\.instance"

/*
	Explicitly stating options to guarantee proper definition of 
	macros in the generated source file, because I've turned on
	-Wundef for all translation units.  
 */
%option never-interactive
%option nomain
%option nostack

/****** rules ****************************************************************/
%%

<INITIAL>{

{POSITIONTOKEN} { NODE_POSITION_UPDATE(*yylval, foo); return yytext[0]; }

^{RES}		{ KEYWORD_UPDATE(*spice_lval, foo); return RES;		}
^{CAP}		{ KEYWORD_UPDATE(*spice_lval, foo); return CAP;		}
^{IND}		{ KEYWORD_UPDATE(*spice_lval, foo); return IND;		}
^{DEV}		{ KEYWORD_UPDATE(*spice_lval, foo); return DEV;		}
^{INST}		{ KEYWORD_UPDATE(*spice_lval, foo); return INST;	}
^{SUBCKT}	{ KEYWORD_UPDATE(*spice_lval, foo); return SUBCKT;	}
^{ENDS}		{ KEYWORD_UPDATE(*spice_lval, foo); return ENDS;	}
^{END}		{ KEYWORD_UPDATE(*spice_lval, foo); return END;		}

{WHITESPACE}	TOKEN_UPDATE(foo);
{NEWLINE}	NEWLINE_UPDATE(foo);

{NUMSCI}	{
	if (token_feedback) {
		cerr << "int = " << yytext << " " << LINE_COL(CURRENT) << endl;
	}
	yylval->_token = new string_token(yytext);
	TOKEN_UPDATE(foo);
	return NUM;
}

{SPICE_ID}	{
	if (token_feedback) {
		cerr << "identifier = \"" << yytext << "\" " << 
			LINE_COL(CURRENT) << endl;
	}
	yylval->_token = new string_token(yytext);
	TOKEN_UPDATE(foo);
	return SPICE_ID;
}

{ESCAPEDID}	{
	if (token_feedback) {
		cerr << "escaped identifier = \"" << yytext+1 << "\" " << 
			LINE_COL(CURRENT) << endl;
	}
	yylval->_token = new string_token(yytext+1);
	TOKEN_UPDATE(foo);
	return ESCAPEDID;
}

.	{
	spice_parse_file_manager.dump_file_stack(cerr);
	/* for everything else that doesn't match... */
	cerr << "unexpected character: \'" << yytext << "\' " <<
		LINE_COL(CURRENT) << endl;
	TOKEN_UPDATE(foo);
	THROW_EXIT;
}
}

%%
/****** user-code ************************************************************/


