%lex
%options case-insensitive
%%

\[([^\]])*?\]	   								return 'BRALITERAL'
\`([^\]])*?\`	   								return 'BRALITERAL'
(['](\\.|[^']|\\\')*?['])+                      return 'STRING'
(["](\\.|[^"]|\\\")*?["])+                      return 'STRING'

\/\*(.*?)\*\/									return /* skip comments */
"--"(.*?)($|\r\n|\r|\n)							return /* return 'COMMENT' */

\s+                                             /* skip whitespace */
'AXIS'											return 'AXIS'
'CHAPTERS'										return 'CHAPTERS'
'COLUMNS'										return 'COLUMNS'
'EMPTY'											return 'EMPTY'
'FROM'											return 'FROM'
'HAVING'										return 'HAVING'
'NON'											return 'NON'
'ON'											return 'ON'
'PAGES'											return 'PAGES'
'ROWS'											return 'ROWS'
'SECTIONS'										return 'SECTIONS'
'SELECT'										return 'SELECT'
'WHERE'                                         return 'WHERE'

(\d*[.])?\d+									return 'NUMBER'
'+'												return 'PLUS'
'-' 											return 'MINUS'
'*'												return 'STAR'
'/'												return 'SLASH'
'%'												return 'PERCENT'
'>='											return 'GE'
'>'												return 'GT'
'<='											return 'LE'
'<>'											return 'NE'
'<'												return 'LT'
'='												return 'EQ'
'!='											return 'NE'
'('												return 'LPAR'
')'												return 'RPAR'
'{'												return 'LCUR'
'}'												return 'RCUR'

'.'												return 'DOT'
','												return 'COMMA'
':'												return 'COLON'
';'												return 'SEMICOLON'
'$'												return 'DOLLAR'
'?'												return 'QUESTION'
'&'												return 'AMPERSAND'

[a-zA-Z_][a-zA-Z_0-9]*                       	return 'LITERAL'
<<EOF>>               							return 'EOF'
.												return 'INVALID'

/lex
%
%left COMMA
%left OR
%left AND
%left GT GE LT LE EQ NE
%left IN
%left NOT
%left LIKE
%left PLUS MINUS
%left STAR SLASH PERCENT
%left DOT
/* %left wordsSymb */
/* %left UMINUS */

%start main

%%

Literal : LITERAL
	| BRALITERAL
	| AMPERSAND BRALITERAL { $$ = `${$1} ${$2}` }
	;

main : MdxStatements EOF
		{
		return {statements:$1};
		}
	;

MdxStatements : MdxStatements SEMICOLON MdxStatement
		{ $$ = $1; if($3) $1.push($3); }
	| MdxStatement
		{ $$ = [$1]; }
	;

MdxStatement : { $$ = null; }
	| Select
	| WithSelect
	;

WithSelect : WITH Select ;

Select : SelectClause FromClause HavingClause WhereClause
		{ $$ = {axis: $1, from: $2, having: $3, where: $4} } ;

SelectClause : SELECT anything { $$ = $2 } ;

FromClause : FROM anything { $$ = `${$1} ${$2}` } ;

HavingClause : { $$ = null; } | HAVING anything { $$ = `${$1} ${$2}` } ;

WhereClause : { $$ = null; } | WHERE anything { $$ = `${$1} ${$2}` } ;

anything : wordsSymb | anything wordsSymb { $$ = `${$1} ${$2}` };

wordsSymb: Literal | LCUR | LPAR | DOT | RPAR | RCUR | NUMBER | COMMA
    | ON | ROWS | COLUMNS | PAGES | SECTIONS | CHAPTERS | AXIS LPAR NUMBER RPAR;