module type D = sig
  type id
  val root_dir : id
  val mkdir : parent:id -> string -> id
  val access : parent:id -> string -> id
  val get : local:string -> id -> unit
  val put : parent:id -> local:string -> string -> id
  val pp : Format.formatter -> id -> unit
end

module Make (D : D) = struct
  let cache = Hashtbl.create 10

  let getdir ~create ~parent name =
    let key = parent, name in
    if Hashtbl.mem cache key then
      Hashtbl.find cache key
    else
      let id =
        try
          D.access ~parent name
        with Not_found when create ->
          D.mkdir ~parent name
      in
      Hashtbl.replace cache key id;
      id

  let parse ~create path =
    let rec f i parent =
      match String.index_from_opt path i '/' with
      | None ->
        (* last component! *)
        parent, String.(sub path i (length path - i))
      | Some i' ->
        let sub = String.(sub path i (i' -  i)) in
        f (i' + 1) (getdir ~create ~parent sub)
    in
    f 0 D.root_dir

  let get ~local path =
    let parent, name = parse ~create:false path in
    D.get ~local (D.access ~parent name)

  let put ~local path =
    let parent, name = parse ~create:true path in
    D.put ~parent ~local name
end
