open Syntax
open Eval
open Util
open Typing

let rec read_eval_print env tyenv =
  print_string "# ";
  flush stdout;
 	try 
 	let decl = Parser.toplevel Lexer.main (Lexing.from_channel stdin) in
	let (tys, newtyenv) = ty_decl tyenv decl in
	let (eqs, newenv) = eval_decl env decl in
		let rec print_eqs tys eqs = 
			(match (tys, eqs) with
					(ty :: ty_tl, (id, v) :: eq_tl) ->
						if not (exists_var id eq_tl) then
							(Printf.printf "val %s : " id;
							pp_ty ty;
							print_string " = ";
							pp_val v;
							print_newline());
						print_eqs ty_tl eq_tl
				| _ -> read_eval_print newenv newtyenv)
		in print_eqs tys eqs
	with 
			Error s ->
				print_string ("Fatal Error -> " ^ s);
				print_newline();
				read_eval_print env tyenv
		|	Parser.Error ->
				print_string ("Fatal Error -> Parser Error");
				print_newline();
				read_eval_print env tyenv
		|	Failure s ->
				print_string ("Fatal Error -> " ^ s);
				print_newline();
				read_eval_print env tyenv

let initial_tyenv =
	Environment.extend "i" (tysc_of_ty TyInt)
		(Environment.extend "ii" (tysc_of_ty TyInt)
			(Environment.extend "iii" (tysc_of_ty TyInt)
				(Environment.extend "iv" (tysc_of_ty TyInt)
					(Environment.extend "v" (tysc_of_ty TyInt)
						(Environment.extend "x" (tysc_of_ty TyInt) Environment.empty)))))

let initial_env =
	Environment.extend "i" (IntV 1)
		(Environment.extend "ii" (IntV 2)
			(Environment.extend "iii" (IntV 3)
				(Environment.extend "iv" (IntV 4)
					(Environment.extend "v" (IntV 5)
						(Environment.extend "x" (IntV 10) Environment.empty)))))

let _ = read_eval_print initial_env initial_tyenv

