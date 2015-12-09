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



main : AxisSpecificationList EOF { return $1; } ;

AxisSpecificationList : OnClause { $$ = [$1]; }
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

SetClause : Set { $$ = {sets:[].concat($1), nonEmpty: false}; }
    | NON EMPTY Set { $$ = {sets:[].concat($3), nonEmpty: true}; }
;

Set : '{' Tuples '}' { $$ = {tuples: $2}; }
	| Set '*' Set { $$ = [].concat($1).concat($3); }
;

Tuples : Entity
    | Tuples ',' Entity { $$ = $1 + $2 + $3; }
    | Tuples '*' Entity { $$ = $1 + $2 + $3; }
;

Func : Entity '(' ')' { $$ = $1 + $2 + $3; }
    | Entity '(' Tuples ')' { $$ = $1 + $2 + $3 + $4; } ;

Entity : ENTITY | Entity ENTITY { $$ = $1+$2; } | Entity NUMBER { $$ = $1+$2; } | Func ;

%%
