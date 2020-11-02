(** 
   The main entry point for the game interface.
*)

(* You are free to add more code here. *)
val main : unit -> unit
val play_game : string -> unit
val read_input :  unit -> unit
val game_loop : Adventure.t -> State.t -> 'a
val string_from_list : string list -> string