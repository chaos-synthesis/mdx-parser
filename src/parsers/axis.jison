%lex
%options case-insensitive
%%

\s+                                             /* skip whitespace */
(\d*[.])?\d+									return 'NUMBER'

'('												return '('
')'												return ')'
'{'												return '{'
'}'												return '}'
'*'												return '*'
','												return ','
'&'												return '&'

'NON'											return 'NON'
'EMPTY'											return 'EMPTY'
'ON'						                    return 'ON'
'ROWS'											return 'ROWS'
'COLUMNS'					                    return 'COLUMNS'
'PAGES'                                         return 'PAGES'
'SECTIONS'                                      return 'SECTIONS'
'CHAPTERS'                                      return 'CHAPTERS'
'AXIS'                                          return 'AXIS'

<<EOF>>               							return 'EOF'
.+?                              	            return 'ENTITY'

/lex
%
%left ','
%left NOT
%left '*'

%start main

%%



main : AxisSpecificationList EOF { return [].concat($1); } ;

AxisSpecificationList : OnClause
    | AxisSpecificationList ',' OnClause { $$ = [].concat($1).concat($3); }
    ;

OnClause : SetClause ON ROWS { $$ = {type:$3, entites:$1}; }
	| SetClause ON COLUMNS { $$ = {type:$3, entites:$1}; }
	| SetClause ON PAGES { $$ = {type:$3, entites:$1}; }
	| SetClause ON SECTIONS { $$ = {type:$3, entites:$1}; }
	| SetClause ON CHAPTERS { $$ = {type:$3, entites:$1}; }
	| SetClause ON AXIS '(' NUMBER ')' { $$ = {type:$3, entites:$1, pos:$5}; }
	| SetClause ON NUMBER { $$ = {pos:$3, entites:$1}; }
	;

SetClause : Set | NON EMPTY Set { $$ = $3; $$.nonEmpty = true; };

Set : '{' Tuples '}' { $$ = [].concat($2); }
	| Set '*' Set { $$ = [].concat($1).concat($3); }
	;

Tuples : Entity
    | Tuples ',' Entity { $$ = $1 + $2 + $3; };

Entity : ENTITY | Entity ENTITY { $$ = $1+$2; } | Entity NUMBER { $$ = $1+$2; } ;

%%
