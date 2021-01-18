(*
 * CS 3110 Fall 2017 A1
 * Author: ADEL Refat ali
 * NetID: NAN
 *
 * Acknowledge here any contributions made to your solution that
 * did not originate from you or from the course staff:
 *
 *)

(*********************************************************)
(* PART 1 *)

(*********************************************************)

let upperChar c =  (Char.code c <= 90) && (Char.code c >= 65)
(** returns [true] if [c] is A..Z otherwise [false] *)

let invIndex pos = if (pos <= 25) && (pos >= 0) then Char.chr ( pos + 65 ) else raise (Invalid_argument "pos must be between 0-25")
let index c =
(** [index c] is the 0-based index of [c] in the alphabet. *)  
	(* make sure it's an upper case letter *)
	if upperChar c
	(* remap it *)
	then ((Char.code c) - 65)
	(* throw exep if not uppercase char A-Z *)
	else raise (Invalid_argument "[c] must be [char] A-Z")
	
(* NOTE:  [failwith "Unimplemented"] raises an exception to indicate
   that the function has not been finished.  You should delete that
   line of code and replace it with your own code. *)

(*********************************************************)
(* PART 2 *)
(*********************************************************)

(* [map_r_to_l wiring top_letter input_pos] is the left-hand output position
 * at which current would appear when current enters at right-hand input
 * position [input_pos] to a rotor whose wiring specification is given by
 * [wiring].  The orientation of the rotor is given by [top_letter], 
 * which is the top letter appearing to the operator in the rotor's 
 * present orientation.
 * requires: 
 *  - [wiring] is a valid wiring specification.
 *  - [top_letter] is in 'A'..'Z'
 *  - [input_pos] is in 0..25
 *)
let rec list_car ch = match ch with
    | "" -> []
    | ch -> (String.get ch 0 ) :: (list_car (String.sub ch 1 ( (String.length ch)-1) ) )  ;;
let rec char_list_to_string lst = 
	match lst with
	|[] ->""
	|h::t -> (h |> String.make 1  )^ (char_list_to_string t)
let string_int_lst wiring =  
	 list_car wiring |> List.map (Char.code) |> List.sort  Stdlib.compare
	 

let validWiring wiring = 
	let sorted = string_int_lst  wiring 
	in 
	begin
	
	(String.length wiring == 26) 
	&& 
	(List.hd sorted == 65) && (List.hd (List.rev sorted) == 90)  
	&&
	(List.fold_left (fun acc x-> acc + x ) 0 sorted ) == 2015
	
	end
	
let rec modulo n = if (n <= 25) && (n >= 0) then n else if (n > 25) then modulo (n - 26) else modulo(n + 26)  		  
let map_r_to_l wiring top_letter input_pos =

	(* satisfies input requirements *)
	if (input_pos <= 25) && (input_pos >= 0) 
	then 
		if  upperChar top_letter 
		then if validWiring wiring then 
		
		modulo (index (String.get wiring ( modulo (input_pos + index top_letter))) - index top_letter)
		
		else raise (Invalid_argument "Invalid Wiring")
		else raise (Invalid_argument "Invalid top_letter")
	else raise (Invalid_argument "Invalid input_pos")

                                                                  (* 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 *)
(* 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 *)


		

let map_l_to_r wiring top_letter input_pos = 
(* [map_l_to_r] computes the same function as [map_r_to_l], except
 * for current flowing left to right. *)
	(* satisfies input requirements *)
	if (input_pos <= 25) && (input_pos >= 0) 
	then 
		if  upperChar top_letter 
		then if validWiring wiring then 
		
		modulo( ( String.index  wiring (invIndex ( modulo (input_pos + index top_letter)) ) ) - index top_letter) 
		
		else raise (Invalid_argument "Invalid Wiring")
		else raise (Invalid_argument "Invalid top_letter")
	else raise (Invalid_argument "Invalid input_pos")

	
(*********************************************************)
(* PART 3 *)
(*********************************************************)

(* [map_refl wiring input_pos] is the output position at which current would 
 * appear when current enters at input position [input_pos] to a reflector 
 * whose wiring specification is given by [wiring].
 * requires: 
 *  - [wiring] is a valid reflector specification.
 *  - [input_pos] is in 0..25
 *)
let rec reflectedWires allwiring remainings = 
	match remainings with
		|[] -> true
		| h::t -> 
		(index (String.get allwiring (index h)) == (String.index allwiring h) ) &&  (reflectedWires allwiring t)
			

let validReflector wiring =
	validWiring wiring 
	&&
	(reflectedWires wiring (list_car wiring))

let map_refl wiring input_pos =
	if validReflector wiring
	then 
		map_r_to_l wiring 'A' input_pos
	else raise (Invalid_argument "Invalid wiring")

(*********************************************************)
(* PART 4 *)
(*********************************************************)

(* [map_plug plugs c] is the letter to which [c] is transformed
 * by the plugboard [plugs].
 * requires:
 *  - [plugs] is a valid plugboard
 *  - [c] is in 'A'..'Z' 
 *)
let partialPairs (p1l,p1r) (p2l,p2r) = (p1l = p2l || p1r = p2r) || (p1l = p2r || p1r = p2l)

let rec contradicts pair pairLst = 
(** returns true if any part of [pair] is found in pairLst
	, Example: findMatch (1,'a') [(5,'z');('a',2)] -> true
 *)
	match pairLst with 
	|[] -> false
	|h::t -> partialPairs h pair || contradicts pair t

let rec validPlugs plugs = 
	match plugs with 
	| [] -> true
	| h::t -> not (contradicts h t) && validPlugs t
let rec map_plug plugs c =
	if validPlugs plugs
	then begin
	match plugs with
	| [] -> c
	| (e1,e2)::t -> if (e1 = c) then e2 else if (e2 = c) then e1 else map_plug t c 
	end

	else raise (Invalid_argument "Invalid plugs") 

(*********************************************************)
(* PART 5 *)
(*********************************************************)

type rotor = {
	wiring : string;
	turnover : char;
}

type oriented_rotor = {
	rotor : rotor;
	top_letter : char;
}

type config = {
	refl : string;
	rotors : oriented_rotor list;
	plugboard : (char*char) list;
}

(* [cipher_char config c] is the letter to which the Enigma machine 
 * ciphers input [c] when it is in configuration [config].
 * requires:
 *  - [config] is a valid configuration
 *  - [c] is in 'A'..'Z'
 *)

let rec map_rotors map_rotor (rotors:oriented_rotor list) (input_pos:int) = 
	match rotors with
	| [] -> input_pos
	| {rotor;top_letter}::r -> 
	let outpos = map_rotor rotor.wiring top_letter input_pos 
	in (map_rotors map_rotor r outpos)

(* 
let rec map_rotors_r_to_l (rotors:oriented_rotor list) (input_pos_right:int) = 
	match rotors with
	| [] -> input_pos_right
	| {{wiring;turnover};top_letter}::r -> 
	let outpos = map_r_to_l wiring top_letter input_pos_right 
	in (map_rotors_r_to_l r outpos)
	 *)

let  map_rotors_r_to_l (rotors:oriented_rotor list) (input_pos_right:int) = map_rotors map_r_to_l (List.rev rotors) input_pos_right
		 
let map_rotors_l_to_r (rotors:oriented_rotor list) (input_pos_left:int)  = map_rotors map_l_to_r rotors input_pos_left
		  


let cipher_char config c =
	let {refl;rotors;plugboard} = config
	in map_plug plugboard c |> index |> map_rotors_r_to_l rotors |> map_refl refl |> map_rotors_l_to_r rotors |> invIndex |> map_plug plugboard




(*********************************************************)
(* PART 6 *)
(*********************************************************)

(* [step config] is the new configuration to which the Enigma machine 
 * transitions when it steps beginning in configuration [config].
 * requires: [config] is a valid configuration
 *)


(* -------------------------------------- *)
(* 
type rotor = {
	wiring : string;
	turnover : char;
}

type oriented_rotor = {
	rotor : rotor;
	top_letter : char;
}

type config = {
	refl : string;
	rotors : oriented_rotor list;
	plugboard : (char*char) list;
} *)

(* 
let rotor_I_wiring   = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
let rotor_II_wiring  = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
let rotor_III_wiring = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
let refl_B_wiring    = "YRUHQSLDPXNGOKMIEBFZCWVJAT"

let refl_B_wiring    = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let id_config = {
  refl = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
  rotors = [];
  plugboard = [];
}
let rotor_I = {
  wiring = rotor_I_wiring;
  turnover = 'Q';
}

let rotor_II = {
  wiring = rotor_II_wiring;
  turnover = 'E';
}

let rotor_III = {
  wiring = rotor_III_wiring;
  turnover = 'V';
}

let cipher_char_ex_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'A'};
    {rotor = rotor_II;  top_letter = 'A'};
    {rotor = rotor_III; top_letter = 'A'};
  ];
  plugboard = [];
}

let step_ex2_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'E'};
    {rotor = rotor_I;   top_letter = 'R'};
  ];
  plugboard = [];
}

let cipher_ex_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'F'};
    {rotor = rotor_II;  top_letter = 'U'};
    {rotor = rotor_III; top_letter = 'N'};
  ];
  plugboard = ['A','Z'];
}
let cipher_ex2_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'D'};
    {rotor = rotor_II;  top_letter = 'C'};
    {rotor = rotor_III; top_letter = 'E'};
  ];
  plugboard = ['A','Z'];
} *)
(* -------------------------------------- *)
let cycleLetters (c:char) = let pos = index c in if pos < 25 then invIndex (pos + 1) else invIndex 0
let rec getTurnovers (rotors:oriented_rotor list) =
	match rotors with 
	|[]->[]
	| {rotor;top_letter}::t -> rotor.turnover :: (getTurnovers t)

let ignoreLRotorTurn turnovers = 
	match turnovers with    
	|[]->[]
	|h::t -> '#'::t
	
let step {refl;rotors;plugboard} =
	let reversed_turnovers = getTurnovers rotors |> ignoreLRotorTurn |> List.rev in 
	(* exclude turnover of most left rotor *)
	let rec updateRotors reversed_rotors reversed_turnovers (stepNext:bool) (rightmost:bool)= 
		match (reversed_rotors,reversed_turnovers) with
		|([],_) -> []
		(* |({rotor;top_letter}::[],_)-> step the right most *)
		|({rotor;top_letter}::t',h::t) -> 
		if (top_letter = h  || stepNext =true || rightmost = true ) 
		then {rotor=rotor;top_letter= cycleLetters top_letter}::(updateRotors t' t (top_letter=h) false) 
		else {rotor=rotor;top_letter= top_letter}::updateRotors t' t false false
		|(_,[]) -> reversed_rotors
	
	in 
	let updatedRotors = updateRotors (List.rev rotors) reversed_turnovers false true |> List.rev 
	in {refl = refl;rotors = updatedRotors ; plugboard=plugboard}
	 
	


(*********************************************************)
(* PART 7 *)
(*********************************************************)

(* [cipher config s] is the string to which [s] enciphers
 * when the Enigma machine begins in configuration [config].
 * requires: 
 *   - [config] is a valid configuration 
 *   - [s] contains only uppercase letters
 *)
let rec cipher_helper config s = 
		match s with
		|[] -> []
		|h::t -> 
		let newConfig = step config in 
		(cipher_char newConfig h):: cipher_helper newConfig t
	
	 
let cipher config s = cipher_helper config (list_car s) |> char_list_to_string
		
(* 	
	let length = String.length s in 
	if length > 0 then ((String.get s 0) |> cipher_char (step config) ) ^ else  *)