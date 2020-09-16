type error_location = {
  e_line_number : int;
  e_start : int;
  e_end : int;
}

val string_of_error_location : error_location -> string

type simple_error = [
  | `SyntaxError of error_location
  | `UnterminatedString of int (* line number *)
]

type error = [
  | simple_error
  | `IntOverflow of (int * string) (* line number and offending string *)
]

val string_of_simple_error : simple_error -> string
val string_of_error : error -> string

type value = [ `Int of int | `Float of float | `String of string ]
type dense = value list
type sparse = (int * value) list

type row = [`Sparse of sparse | `Dense of dense ]
type row_or_error = (row, error) result
type header = [`Sparse of (int * string) list | `Dense of string list]

type row_seq = row_or_error Seq.t
val of_channel : no_header:bool -> in_channel ->
  (header option * row_seq, error) result

val row_of_string : string -> (row, [ error | `EOF ] ) result
(* parse a single row of a csv file; the string may have trailing
   comments or newlines. *)

type simple_row_or_error = (string list, simple_error) result
type simple_row_seq = simple_row_or_error Seq.t

val simple_of_channel : no_header:bool -> in_channel ->
  (string list option * simple_row_seq, simple_error) result

