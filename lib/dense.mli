val read_num_csv    : ?header:bool -> string -> string list option * float  list list
val read_int_csv    : ?header:bool -> string -> string list option * int    list list
val read_string_csv : ?header:bool -> string -> string list option * string list list
