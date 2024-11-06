Require Import Arith List String.
From Machine Require Import Parser Lexer.
Import MenhirLibParser.Inter.
Open Scope string_scope.

Import ListNotations.

Inductive op : Type :=
| PUSH : nat -> op
| ADD : op.

Fixpoint eval (e : Syntax.expr) : nat :=
  match e with
  | Syntax.ValE n => n
  | Syntax.AddE e1 e2 => eval e1 + eval e2
  end.

Definition stack := list nat.
Definition code := list op.

Fixpoint exec (c : code) (s : stack) : stack :=
  match c, s with
  | [], s => s
  | (PUSH n :: c'), s => exec c' (n :: s)
  | (ADD :: c'), (m :: n :: s') => exec c' ((n + m) :: s')
  | (ADD :: _), _ => []  (* Error case *)
  end.

Fixpoint compile' (e : Syntax.expr) (c : code) : code :=
  match e with
  | Syntax.ValE n => PUSH n :: c
  | Syntax.AddE e1 e2 => compile' e1 (compile' e2 (ADD :: c))
  end.

Definition compile (e : Syntax.expr) : code := compile' e [].

Lemma compile'_exec_eval :
  forall e s c, exec (compile' e c) s = exec c (eval e :: s).
Proof.
  intros e.
  induction e; intros s c.
  - simpl.
    reflexivity.
  - simpl.
    rewrite IHe1.
    rewrite IHe2.
    reflexivity.
Qed.

Theorem compile_exec_eval :
  forall e, exec (compile e) [] = [eval e].
Proof.
  intros e.
  unfold compile.
  rewrite compile'_exec_eval.
  simpl.
  reflexivity.
Qed.

Example test_compile_val : compile (Syntax.ValE 5) = [PUSH 5].
Proof. reflexivity. Qed.

Example test_compile_add : compile (Syntax.AddE (Syntax.ValE 3) (Syntax.ValE 4)) = [PUSH 3; PUSH 4; ADD].
Proof. reflexivity. Qed.

Example test_exec_val : exec (compile (Syntax.ValE 5)) [] = [5].
Proof. reflexivity. Qed.

Example test_exec_add : exec (compile (Syntax.AddE (Syntax.ValE 3) (Syntax.ValE 4))) [] = [7].
Proof. reflexivity. Qed.

Definition parse_string s :=
  match option_map (Parser.parse_expr 50) (Lexer.lex_string s) with
  | Some (Parsed_pr f _) => Some f
  | _ => None
  end.

Definition example := "(1 + (2 + (3 + (4 + 5))))".

Definition example_ops := option_map compile (parse_string example).

Compute example_ops.

Compute option_map (fun x => exec x []) (example_ops).