(* Note: You may introduce new code anywhere in this file. *) 

(* TODO: replace [unit] with a type of your own design. *)
type room_id = Adventure.room_id
type adventure = Adventure.t

type t = {adv:adventure;visited:room_id list; current_room : room_id}

let init_state adv =
  let starting_room = Adventure.start_room adv in 
  {adv = adv ;visited = [starting_room]; current_room = starting_room }


let current_room_id st =
  st.current_room

let visited st =
  st.visited

type result = Legal of t | Illegal

let go ex adv st =
  (* let possible_exists = Adventure.exits adv st.current_room  in 
  if List.mem ex possible_exists then  *)
  try 
  let next_room = Adventure.next_room adv st.current_room ex in 

  (* else Illegal *)
    let uniq_visited = next_room::st.visited |> List.sort_uniq (fun a b -> if a = b then 0 else 1) in 

      Legal {adv = adv; visited =uniq_visited ; current_room = next_room} 
  with 
  | _ -> Illegal    