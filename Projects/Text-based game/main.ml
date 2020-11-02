(** [play_game f] starts the adventure in file [f]. *)

let read_json filename = Yojson.Basic.from_file filename  

let rec string_from_list l = 
  match l with
  |[] -> ""
  |h::t -> h ^ " " ^(string_from_list t)


let rec game_loop adv (st:State.t) = 
(* print the desc of the current room *)

(* prompt for input command *)
print_string "> ";
match  read_line () |> Command.parse with 
| exception Command.Empty -> print_endline "Empty Command, try again.\n" ; game_loop adv st 
| exception Command.Malformed -> print_endline "Wrong Command, try again.\n" ; game_loop adv st 
| Command.Quit -> exit 0
| Command.Go t -> let exit = t |>  string_from_list |> String.trim  in 
  match  State.go exit adv st with 
  | State.Legal st -> (Adventure.description  adv (State.current_room_id st))  |> print_endline ; game_loop adv st
  | State.Illegal ->  print_endline "Can't Do that!.\n"; game_loop adv st
  

let rec read_input () = 
  print_endline "Please enter the name of the game file you want to load.\n";
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | file_name -> play_game file_name


and play_game f =
  try
  (* begin *)
    let json = read_json f in  (* read the file *)
    let adv = Adventure.from_json json in (* parse the json file *)
    
    let init = State.init_state adv in(*   create the initial state of the game *)
    (Adventure.description  adv (State.current_room_id init))  |> print_endline; 
    
    game_loop adv init
  (* end *)
  with 
  | Sys_error f -> print_endline ("Couldn't Read " ^ f (* ^ " \nPlease Enter a valid JSON File.\n " *)) ; read_input () (* entered file name and got rejected by read_json --> then asking for another file again *)
  | Adventure.InvalidJson -> print_endline "The entered file isn't a valid JSON Scheme " ; read_input () (*  entered a file and got rejected by from_json --> then asking for another file again *)


(** [main ()] prompts for the game to play, then starts it. *)
let  main () =
  ANSITerminal.(print_string [red]
                  "\n\nWelcome to the 3110 Text Adventure Game engine.\n");
  print_endline "Please enter the name of the game file you want to load.\n";
  print_string  "> ";
  match read_line () with
  | exception End_of_file -> ()
  | file_name -> play_game file_name

(* Execute the game engine. *)
let () = main ()
