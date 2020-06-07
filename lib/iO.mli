type error_location = {
  e_line_number : int;
  e_start : int;
  e_end : int;
}

val string_of_error_location : error_location -> string

type error = [
  | `SyntaxError of error_location
  | `UnterminatedString of int (* line number *)
  | `IntOverflow of (int * string) (* line number and offending string *)
]

val string_of_error : error -> string

type row = ([`Sparse of Types.sparse | `Dense of Types.dense ], error) result

type row_seq = row Seq.t
val of_channel : no_header:bool -> in_channel ->
  (string list * row_seq, error) result

val row_of_string : string -> [ `Ok of Types.row | error ]
(* parse a single row of a csv file; the string may have trailing
   comments or newlines. *)
