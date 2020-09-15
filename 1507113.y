
%{
	#include<stdio.h>
	int cnt=1,cntt=0,val;

	typedef struct A {
    char *str;
    int n;
	}obj;
	obj store[1000],sym[1000];
	void insrt1 (obj *p, char *s, int n);
	
	int cnt2=1; 
	void insrt2 (obj *p, char *s, int n);
	
%}
%union 
{
        int number;
        char *string;
}

%token <number> NUM
%token <string> VAR 
%token <string> IF ELSE VOIDMAIN INT FLOAT CHAR LP RP LB RB CM SM PLUS MINUS MULT DIV ASSIGN FOR COL WHILE BREAK COLON DEFAULT CASE SWITCH inc importtt inpit
%type <string> statement
%type <number> expression
%nonassoc IFX
%nonassoc ELSE
%left LT GT
%left PLUS MINUS
%left MULT DIV


%%

program: VOIDMAIN LP RP LB cstatement RB { printf("\nsuccessful compilation\n"); }
	 ;

cstatement: /* empty */

	| cstatement statement
	
	| cdeclaration
	;

cdeclaration:	TYPE ID1 SM	{ printf("\nvalid declaration\n"); }
		  
			;
			
TYPE : INT

     | FLOAT

     | CHAR
     ;

ID1  : ID1 CM VAR	{
						if(checking_func1($3) == 1)
						{
							printf("%s is already declared\n", $3 );
						}
						else
						{
							insrt1 (&store[cnt],$3, cnt);
							cnt++;
							
						}
			}

     |VAR	{
				if(checking_func1($1) == 1)
				{
					printf("%s is already declared\n", $1  );
				}
				else
				{
					insrt1 (&store[cnt],$1, cnt);
							cnt++;
				}
			}
     ;

statement: SM
	| SWITCH LP expression RP LB BASE RB    {printf("SWITCH case.\n");val=$3;} 

	| expression SM 			{ printf("\nvalue of expression: %d\n", ($1)); }

        | VAR ASSIGN expression SM 		{
							if(checking_func1($1)){
							insrt2 (&sym[$3], $1, $3);
							
							//printf("\n(%s) Value of the variable: %d\t\n",sym[$3].str,sym[$3].n); 
							printf("\n(%s) Value of the variable: %d\t\n",$1,$3);
							}
							else {
							printf("%s not declared yet\n",$1);
							}
							
						}

	| IF LP expression RP LB expression SM RB %prec IFX {
								if($3)
								{
									printf("\nvalue of expression in IF: %d\n",($6));
								}
								else
								{
									printf("\ncondition value zero in IF block\n");
								}
							}

	| IF LP expression RP LB expression SM RB ELSE LB expression SM RB {
								 	if($3)
									{
										printf("\nvalue of expression in IF: %d\n",$6);
									}
									else
									{
										printf("\nvalue of expression in ELSE: %d\n",$11);
									}
								   }
	| FOR LP NUM COL NUM RP LB expression RB     {
	   int i=0;
	   
	   for(i=$3;i<$5;i++){
	   printf("for loop statement\n");
	   }
	}
	| WHILE LP NUM GT NUM RP LB expression RB   {
										int i;
										printf("While LOOP: ");
										for(i=$3;i<=$5;i++)
										{
											printf("%d ",i);
										}
										printf("\n");
	}
	;


	
			BASE : Bas   
				 | Bas Dflt 
				 ;

			Bas   : /*NULL*/
				 | Bas Cs     
				 ;

			Cs    : CASE NUM COL expression SM   {
				//printf("NUM: %d val: %d\n",$2,val);
						if($2==2){
							  cntt=1;
							  printf("\nCase No : %d  and Result :  %d\n",$2,$4);
						}
					}
				 ;

			Dflt    : DEFAULT COLON NUM SM    {
						if(cntt==0){
							printf("\nResult in default Value is :  %d \n",$3);
						}
					}
				 ;    
	

	
	
expression: NUM				{ $$ = $1; 	}

	| VAR				{ $$ = sym_insrt_func($1); printf("Variable value: %d",$$)}

	| expression PLUS expression	{ $$ = $1 + $3; }

	| expression MINUS expression	{ $$ = $1 - $3; }

	| expression MULT expression	{ $$ = $1 * $3; }

	| expression DIV expression	{ 	if($3) 
				  		{
				     			$$ = $1 / $3;
				  		}
				  		else
				  		{
							$$ = 0;
							printf("\ndivision by zero\t");
				  		} 	
				    	}

	| expression LT expression	{ $$ = $1 < $3; }

	| expression GT expression	{ $$ = $1 > $3; }

	| LP expression RP		{ $$ = $2;	}
	| inc expression inc         { $$=$2+1; printf("inc: %d\n",$$);}
	;
%%


void insrt1 ( obj *p, char *s, int n)
{
  p->str = s;
  p->n = n;
}

int
checking_func1(char *key)
{
    int i = 1;
    char *name = store[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return store[i].n;
        name = store[++i].str;
    }
    return 0;
}


void insrt2 (obj *p, char *s, int n)
{
  p->str = s;
  p->n = n;

}

int
sym_insrt_func(char *key)
{
    int i = 1;
    char *name = sym[i].str;
    while (name) {
        if (strcmp(name, key) == 0)
            return sym[i].n;
        name = sym[++i].str;
    }
    return 0;
}





int yywrap()
{
return 1;
}


yyerror(char *s){
	printf( "%s\n", s);
}

