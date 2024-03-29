(* ML interpreter / type reconstruction *)
type id = string

type binOp = Plus | Minus | Mult | Eq | Lt | Gt | And | Or | Cons | Join | Append

type tyvar = int

type ty = TyInt | TyBool | TyVar of tyvar | TyFun of ty * ty | TyList of ty | TyVariant of string | TyTuple of ty list | TyString | TyNone

type tysc = TyScheme of tyvar list * ty

let tysc_of_ty ty = TyScheme ([], ty)

type exp =
    Var of id
  | ILit of int
  | BLit of bool
  | SLit of string
  | BinOp of binOp * exp * exp
  | IfExp of exp * exp * exp
  | LetExp of ((exp * exp) list) * exp
  | FunExp of (exp list) * exp
  | DFunExp of (exp list) * exp
  | MatchExp of exp * ((exp * exp) list)
  | ListExp of exp list
  | AppExp of exp * exp
  | LetRecExp of ((id * (exp list) * exp) list) * exp
  | ConstrExp of id * exp
  | TupleExp of exp list
	| None

type texp = 
		TupleT of texp list
	| ListT of texp
	| TVar of string
	| TNone

type program = 
    Exp of exp
  | Decl of ((exp * exp) list) list
  | RecDecl of (id * (exp list) * exp) list
 	| TypeDecl of id * texp
 	| VariantDecl of id * ((id * texp) list)
