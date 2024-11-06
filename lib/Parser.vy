(* -*- mode: prog; -*- *)

%{
Module Syntax.
Inductive expr : Type :=
| ValE : nat -> expr
| AddE : expr -> expr -> expr.
End Syntax.
%}

%token ADD LPAREN RPAREN EOF
%token <nat> NUM

%start <Syntax.expr> parse_expr

%type <Syntax.expr> p_expr
%type <Syntax.expr> p_factor
%type <Syntax.expr> p_atom

%%

parse_expr : p_expr EOF  { $1 }

p_atom :
  | NUM                  { Syntax.ValE $1 }
  | LPAREN p_expr RPAREN { $2 }

p_expr :
  | p_factor             { $1 }
  | p_expr ADD p_factor  { Syntax.AddE $1 $3 }

p_factor :
  | p_atom               { $1 }