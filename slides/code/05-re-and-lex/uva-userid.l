USERID	^[a-z][a-z][a-z]?([0-9][a-z][a-z]?)?$
%%
{USERID}   { printf("Found a UVa userid: %s\n",yytext); }
.|\n       { /* ignore other input */ }
%%
