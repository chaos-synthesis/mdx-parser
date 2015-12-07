%lex
%options case-insensitive
%%

\s+                                             /* skip whitespace */
\[([^\]])*?\]	   								return 'BRALITERAL'
\`([^\]])*?\`	   								return 'BRALITERAL'

'('												return '('
')'												return ')'
'*'												return '*'
'/'												return '/'
'+'												return '+'
'-'												return '-'
'>'												return '>'
'<'												return '<'
'>='											return '>='
'<='											return '<='
'='												return '='
'!='											return '!='
','												return ','
'.'												return '.'
'&'												return '&'

[a-zA-Z_][a-zA-Z_0-9]*                          return 'LITERAL'
<<EOF>>               							return 'EOF'

/lex
%
%left ','

%start main

%%

main : ExprList EOF { return [].concat($1); } ;

ExprList : { $$ = []; }
    | Expression { $$ = [$1]; }
    | ExprList ',' Expression { $$ = $1.concat([$3]); }
;

Expression : Entity
    | Expression Op Entity { $$ = {name: $2, args: [$1, $3]} }
;

Entity : Literal { $$ = [$1.replace(/^['"\[]|['"\]]$/g, '')]; }
    | Entity '.' Literal { $$ = $1.concat($3.replace(/^['"\[]|['"\]]$/g, '')); }
    | Func
    | '(' ExprList ')' { $$ = $2; } ;

Func : Literal '(' ExprList ')' { $$ = {name: $1, args: $3}} ;

Literal : LITERAL
	| BRALITERAL
	| AMPERSAND BRALITERAL { $$ = `${$1} ${$2}` }
	;

Op : '*' | '/' | '+' | '-' | '>' | '<' | '>=' | '<=' | '=' | '!='
	;

%%
