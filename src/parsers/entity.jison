%lex
%options case-insensitive
%%

\s+                                             /* skip whitespace */
\[([^\]])*?\]/*]*/	   								return 'BRALITERAL'
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
%left OP

%start main

%%

main : ExprList EOF { return $1; } ;

ExprList : Expression { $$ = [$1]; }
    | ExprList ',' Expression { $$ = $1.concat($3); }
;

Expression : Entity { $$ = {entities: [$1]}; }
    | '(' Tuples ')' { $$ = $2 }
    | Expression Op Entity { $$ = {name: $2, left: $1, right: $3, isExpression: true} }
    | Expression Op '(' Tuples ')' { $$ = {name: $2, left: $1, right: $4, isExpression: true} }
;

Func : Literal '(' ')' { $$ = {name: $1, args: [], isFunction: true}}
    | Literal '(' Tuples ')' { $$ = {name: $1, args: $3, isFunction: true}} ;

Tuples : Entity { $$ = {entities: [$1]}; }
    | Tuples ',' Entity { $$ = $1; $$.entities.push($3); }
;

Entity : Literal {
        $$ = {
            name: $1.replace(/^['"\[]|['"\]]$/g, /*"*/''),
            levels: []
        };
    }
    | Entity '.' Literal {
        $$ = {
            name: $3.replace(/^['"\[]|['"\]]$/g, /*"*/''),
            levels: []
        };
        $$.levels = [$1.name].concat($1.levels);
    }
    | Func
;

Literal : LITERAL
	| BRALITERAL
	| '&' BRALITERAL { $$ = `${$1}${$2}` }
;

Op : '*' | '/' | '+' | '-' | '>' | '<' | '>=' | '<=' | '=' | '!=' ;

%%
