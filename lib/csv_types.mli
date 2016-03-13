type value = [ `Int of int | `Float of float | `String of string ]
type dense = value list
type sparse = (int * value) list
type row = [ `Dense of dense | `Sparse of sparse | `EOF ]

type opt_row = value option list
val parse_opt_row : opt_row -> row
