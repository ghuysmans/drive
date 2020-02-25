type id = string

let root_dir = "root"

let pp = Format.pp_print_string

let mkdir ~parent name =
  Printf.printf "mkdir %s/%s: %!" parent name;
  read_line ()

let access ~parent name =
  Printf.printf "access %s/%s: %!" parent name;
  read_line ()

let get ~local id =
  Printf.printf "%s < %s\n%!" local id

let put ~parent ~local name =
  Printf.printf "%s > %s/%s\n%!" local parent name;
  "uploaded"
