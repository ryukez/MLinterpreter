open Syntax
open Eval

let rec read_eval_print env =
  print_string "# ";
  flush stdout;
  let decl = Parser.toplevel Lexer.main (Lexing.from_channel stdin) in
  try let (id, newenv, v) = eval_decl env decl in
    Printf.printf "val %s = " id;
    pp_val v;
    print_newline();
    read_eval_print newenv
  with Error s ->
  	print_string ("Fatal Error -> " ^ s);
  	print_newline();
  	read_eval_print env

let initial_env = Environment.empty

let _ = read_eval_print initial_env
