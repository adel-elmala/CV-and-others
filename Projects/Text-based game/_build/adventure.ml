(* Note: You may introduce new code anywhere in this file. *) 

open Yojson.Basic.Util


type room_id = string
type exit_name = string
exception UnknownRoom of room_id
exception UnknownExit of exit_name
exception InvalidJson 


type room = {name : room_id;description : string ; exits: (exit_name * room_id) list}

(* TODO: replace [unit] with a type of your own design. *)
type t = {rooms : room list ; starting_room:room_id}

let read_jsn filename = Yojson.Basic.from_file filename  


let extractLstPairs lstPiar =
  match lstPiar with
  |[] -> raise InvalidJson
  |h::t::_ -> (h,t)
  |_::_ -> raise InvalidJson

let extractroom roomLst = 
  match roomLst with 
  | [] -> raise InvalidJson
  | h::h'::t::_ -> (h,h',t)
  | _ -> raise InvalidJson

let rec zip exitLst = 
  match exitLst with
  | [] -> []
  | (h1,h2)::(t1,t2)::t' ->  (h2,t2):: zip t'
  | _ -> raise InvalidJson
let rec flatten lstoflsts =
  match lstoflsts with 
  |[] -> []
  |(h::t')::t -> h:: flatten t 
  | _ -> raise InvalidJson

let extractExits exitsLst = exitsLst |> to_list |> List.map to_assoc |> List.map zip |> flatten 
                            
                            |> List.map (fun (a,b) -> (to_string a ,to_string b)) 


let parseRoom roomsLst =
  let ((_,id),(_,desc),(_,exits)) = roomsLst |> extractroom in 

  let (id,desc,exits) = (to_string id , to_string desc ,  exits |> extractExits)
  in {name = id ; description = desc ; exits = exits}







let from_json json = 
  let ((_,rooms),(_,starting_room))  = json |> to_assoc |> extractLstPairs  in 
  let roomsLst = rooms |> to_list |> List.map to_assoc |> List.map parseRoom in 
  {rooms = roomsLst ; starting_room = starting_room |> to_string}


let start_room adv =
  adv.starting_room

let room_ids adv = 
  adv.rooms |> List.map (fun room -> room.name) |> List.sort_uniq (fun a b -> if a = b then 0 else 1)

let searchRoom adv room = let targetRoom = adv.rooms |> List.filter (fun a -> a.name = room) in 
if targetRoom = [] then raise (UnknownRoom room) else targetRoom  

let description adv room =
  let targetRoom = searchRoom adv room |> List.hd in 
  targetRoom.description

let exits adv room = 
  let targetRoom = searchRoom adv room  |> List.hd in 
  targetRoom.exits |> List.map (fun (_,a)-> a) |> List.sort_uniq (fun a b -> if a = b then 0 else 1)

let next_room adv room ex =
   let targetRoom = searchRoom adv room |>  List.hd in 
   targetRoom.exits |> try (List.assoc ex) with _ -> raise (UnknownExit ex)  

let next_rooms adv room =
   let targetRoom = searchRoom adv room |>  List.hd in 
   targetRoom.exits |> List.map (fun (_,a)-> a) |> List.sort_uniq (fun a b -> if a = b then 0 else 1)
(* 

 let j = read_jsn "ho_plaza.json"
let adv = from_json j 

 
let j2 = read_jsn "lonely_room.json"
let adv2 = from_json j2  *)