module C = Drive.Cache.Make (Interactive)

let () =
  let rec f () =
    let l = read_line () in
    ignore @@ C.put ~local:"f" l;
    f ()
  in
  try f ()
  with End_of_file -> ()
