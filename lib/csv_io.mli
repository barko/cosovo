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

type next_row = unit -> [ `Ok of Csv_types.row | error ]
val of_channel : no_header:bool -> in_channel ->
  [ `Ok of string list * next_row | error ]

val row_of_string : string -> [ `Ok of Csv_types.row | error ]
(* parse a single row of a csv file; the string may have trailing
   comments or newlines. *)
