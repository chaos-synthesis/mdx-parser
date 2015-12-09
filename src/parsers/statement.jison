%lex
%options case-insensitive
%%

\/\*(.*?)\*\/									return /* skip comments */
"--"(.*?)($|\r\n|\r|\n)							return /* return 'COMMENT' */

\s+                                             /* skip whitespace */
'WITH'                                          return 'WITH'
'SELECT'										return 'SELECT'
'FROM'											return 'FROM'
'WHERE'                                         return 'WHERE'
'HAVING'										return 'HAVING'

';'												return ';'

<<EOF>>               							return 'EOF'
.+?                              	            return 'strings'

/lex
%
%left ';'

%start main

%%

main : MdxStatements EOF { return $1; } ;

MdxStatements : MdxStatements ';' MdxStatement { $$ = $1; if($3) $1.push($3); }
	| MdxStatement { $$ = [$1]; }
;

MdxStatement : { $$ = null; }
	| Select
	| With Select { $$ = $2; $$.withClause = $1; }
;

With : WithClause { $$ = [$1]; }
    | With ',' WithClause { $$ = $1.push($3); }
;

WithClause : 'WITH' anything { $$ = $2; } ;

Select : SelectClause FromClause HavingClause WhereClause
		{ $$ = {axis: $1, from: $2, having: $3, where: $4} } ;

SelectClause : 'SELECT' anything { $$ = $2 } ;

FromClause : 'FROM' anything { $$ = $2 } ;

HavingClause : { $$ = null; } | 'HAVING' anything { $$ = $2 } ;

WhereClause : { $$ = null; } | 'WHERE' anything { $$ = $2 } ;

anything : strings | anything strings { $$ = $1+$2; } ;
