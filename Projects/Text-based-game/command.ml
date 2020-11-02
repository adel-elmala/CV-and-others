(* Note: You may introduce new code anywhere in this file. *) 

type object_phrase = string list

type command = 
  | Go of object_phrase
  | Quit

exception Empty

exception Malformed

let parse str =
  let command = str |>  String.trim |> String.split_on_char ' '|> List.map String.trim |> List.filter (fun a -> a <> "") in
  match command with 
  |[] -> raise Empty
  |h::t -> let verb = String.lowercase_ascii h in 
  if (verb = "go" && t <> []) then Go t else if ((verb = "quit") && t = [] ) then  Quit else raise Malformed 

