type value = [ `Int of int | `Float of float | `String of string ]
type dense = value list
type sparse = (int * value) list
type row = [ `Dense of dense | `Sparse of sparse | `EOF ]
type header = [ `Dense of string list | `Sparse of (int * string) list ]
type opt_row = value option list
exception Sparse

let unopt = function
  | Some x -> x
  | None -> raise Sparse

let parse_opt_row_dense opt_row =
  List.map unopt opt_row

let parse_opt_row_sparse =
  let rec loop i accu = function
    | None :: tl -> loop (succ i) accu tl
    | (Some v) :: tl -> loop (succ i) ((i,v) :: accu) tl
    | [] -> accu
  in
  fun opt_row ->
    loop 0 [] opt_row

let parse_opt_row opt_row =
  try
    `Dense (parse_opt_row_dense opt_row)
  with Sparse ->
    `Sparse (parse_opt_row_sparse opt_row)
