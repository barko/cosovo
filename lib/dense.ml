exception E of string

let dense_header = function
  | `Dense elements -> elements
  | `Sparse _ -> raise (E "sparse header not supported")

let read_csv ?(header=true) path f =
  let ch = open_in path in
  try
    match IO.of_channel ~no_header:(not header) ch with
    | Ok (header_opt, row_seq) ->
      let float_row_seq = Seq.map (
        function
        | Ok (`Dense elements) ->
          List.map f elements
        | Ok (`Sparse _) ->
          raise (E "sparse rows not supported")

        | Error err ->
          raise (E (IO.string_of_error err))

      ) row_seq in
      Option.map dense_header header_opt,
      List.of_seq float_row_seq

    | Error err ->
      raise (E (IO.string_of_error err))
  with (E msg) ->
    close_in ch;
    failwith msg

let num = function
  | `Float f -> f
  | `Int i -> float i
  | `String _ -> raise (E "string elements not supported")

let read_num_csv ?(header=false) path =
  read_csv ~header path num

let int = function
  | `Int i -> i
  | `Float _ -> raise (E "float elements not supported")
  | `String _ -> raise (E "string elements not supported")

let read_int_csv ?(header=true) path =
  read_csv ~header path int

let read_string_csv ?(header=true) path =
  let ch = open_in path in
  try
    match IO.simple_of_channel ~no_header:(not header) ch with
    | Ok (header_opt, row_seq) ->
      let float_row_seq = Seq.map (
        function
        | Ok elements -> elements
        | Error err ->
          raise (E (IO.string_of_simple_error err))

      ) row_seq in
      header_opt, List.of_seq float_row_seq

    | Error err ->
      raise (E (IO.string_of_simple_error err))
  with (E msg) ->
    close_in ch;
    failwith msg

