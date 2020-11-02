open OUnit2
open Enigma

(*******************************************************************)
(* Helper values used throughout this test suite. *)
(*******************************************************************)
 
let rotor_id_wiring  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let rotor_I_wiring   = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
let rotor_II_wiring  = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
let rotor_III_wiring = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
(* let refl_B_wiring    = "YRUHQSLDPXNGOKMIEBFZCWVJAT" *)

let refl_B_wiring    = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let refl_C_wiring    = "FVPJIAOYEDRZXWGCTKUQSBNMHL"
let refl_KD_wiring   = "NSUOMKLIHZFGEADVXWBYCPRQTJ"
let refl_T_wiring    = "GEKPBTAUMOCNILJDXZYFHWVQSR"


(* let refl_C_wiring    = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" *)
(* Not valid *)
let refl_A_wiring    = "AJDKSIRUXBLHWTMCQGZNPYFVOE"



let reflector_B = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let reflector_C = "FVPJIAOYEDRZXWGCTKUQSBNMHL"
let ex3              = "BACDEFGHIJKLMNOPQRSTUVWXYZ"

(*******************************************************************)
(* Tests for Part 1 *)
(*******************************************************************)


let reflector_tests = [

  "refl_B_wiring " >:: (fun _ -> assert_equal true  (validReflector refl_C_wiring ) ~printer:string_of_bool);
  
  "refl_A_wiring " >:: (fun _ -> assert_equal false  (validReflector refl_A_wiring ) ~printer:string_of_bool);
  "reflector_B" >:: (fun _ -> assert_equal true  (validReflector reflector_B ) ~printer:string_of_bool);
  "reflector_C " >:: (fun _ -> assert_equal true  (validReflector reflector_C ) ~printer:string_of_bool);

]

let wiring_tests = [

  "rotor_id_wiring" >:: (fun _ -> assert_equal true  (validWiring rotor_id_wiring));
  "rotor_I_wiring" >:: (fun _ -> assert_equal true  (validWiring rotor_I_wiring));
  "rotor_II_wiring" >:: (fun _ -> assert_equal true  (validWiring rotor_II_wiring));
  "rotor_III_wiring" >:: (fun _ -> assert_equal true  (validWiring rotor_III_wiring));
  "repeated_wiring" >:: (fun _ -> assert_equal false  (validWiring "BDFHJLCPRQXVZNYEIWGAKMUSQO"));
  
  

]

let index_tests = [
  "index A" >:: (fun _ -> assert_equal 0  (index 'A'));
  "index Z" >:: (fun _ -> assert_equal 25 (index 'Z'));
  "index a" >:: (fun _ -> assert_raises (Invalid_argument "[c] must be [char] A-Z") (fun () -> (index 'a')));
  "index C" >:: (fun _ -> assert_equal 2 (index 'C'))
]

(* You do not need to construct a test sweep for [index].  
 * It's too simple of a function for that to be worthwhile. *)

(*******************************************************************)
(* Tests for Part 2 *)
(*******************************************************************)

(* README: In the test case list below, the sweep cases are the first five in
 * the list.  We ask you to follow that format as you complete the
 * rest of the test suite for all the other functions.  You are free
 * to move any provided test cases into the sweep, as long as you 
 * document why the test case is interesting. *)

let map_rl_tests = [
  (* Sweep case 1:  this is interesting because it tests a rotor whose wiring
   *   is as simple as possible:  every contact on the LHS connects directly
   *   to the corresponding contact on the RHS. *)
  "rl_id0" >:: (fun _ -> assert_equal 0 (map_r_to_l rotor_id_wiring 'A' 0)~printer:string_of_int);

  "rl_wrong top_letter" >:: (fun _ ->  assert_raises (Invalid_argument "Invalid top_letter") (fun () -> map_r_to_l rotor_I_wiring 'a' 0 ) ) ;
      
  (* Sweep case 4: TODO *)
  
  (* Sweep case 5: TODO *)
  
  (* Other test cases (not part of the sweep) *)      
  "rl_ex1" >:: (fun _ -> assert_equal 4 (map_r_to_l rotor_I_wiring  'A' 0) ~printer:string_of_int);
  "rl_ex2" >:: (fun _ -> assert_equal 9 (map_r_to_l rotor_I_wiring  'B' 0)~printer:string_of_int);
  (* "rl_ex3" >:: (fun _ -> assert_equal 0 (map_r_to_l ex3 'A' 0)~printer:string_of_int); *)
  "rl_id0" >:: (fun _ -> assert_equal 0 (map_r_to_l rotor_id_wiring 'A' 0) ~printer:string_of_int);

  (* Sweep case 2: Checks to make sure the rl function works with the last leter of the wiring *)
  "rl_I_0" >:: (fun _ -> assert_equal 9 (map_r_to_l rotor_I_wiring 'A' 25) ~printer:string_of_int);

  (* Sweep case 3: Checks to make sure function can handle looping around (in bounds helper function) when the offset causes the input index to be greater than 25 and need to loop back around to the other end of the rotor *)
  "rl_I_1" >:: (fun _ -> assert_equal 1 (map_r_to_l rotor_I_wiring 'E' 25) ~printer:string_of_int);

  (* Sweep case 4: Common input test *)
  "rl_I_2" >:: (fun _ -> assert_equal 7 (map_r_to_l rotor_III_wiring 'G' 7) ~printer:string_of_int);

  (* Sweep case 5: Checks to make sure that the function can handle looping back around from index 0 to the end of the rotor when removing the initial offset from the ending output value *)
  "rl_I_3" >:: (fun _ -> assert_equal 22 (map_r_to_l rotor_III_wiring 'G' 0) ~printer:string_of_int);

  (* Test cases provided in writeup *)
  "rl_4" >:: (fun _ -> assert_equal 17 (map_r_to_l rotor_III_wiring 'O' 14) ~printer:string_of_int);

  (* Other test cases (not part of the sweep) *)
  "rl_ex1" >:: (fun _ -> assert_equal 4 (map_r_to_l rotor_I_wiring  'A' 0) ~printer:string_of_int);
  "rl_ex2" >:: (fun _ -> assert_equal 9 (map_r_to_l rotor_I_wiring  'B' 0) ~printer:string_of_int);

]

let map_lr_tests = [
  (* TODO: test sweep *) 
  
  (* Other test cases (not part of the sweep) *) 
  (* General case with no offset and 0 index starting value *)
  "lr_id0" >:: (fun _ -> assert_equal 0 (map_l_to_r rotor_id_wiring 'A' 0));

  (* General case with 1 offset and 0 index starting value to make sure function can handle simple offset inputs *)
  "lr_id1" >:: (fun _ -> assert_equal 0 (map_l_to_r rotor_id_wiring 'B' 0));

  (* Checks to make sure the function can handle looping around from index 0 to the end of the rotor when subtracting the offset at the end *)
  "lr_id2" >:: (fun _ -> assert_equal 22 (map_l_to_r rotor_I_wiring 'E' 0));


  (* Ensures mapping function can handle offset that would make input value greater than 25, the max value of the rotor *)
  "lr_id3" >:: (fun _ -> assert_equal 25 (map_l_to_r rotor_II_wiring 'B' 25));

  (* General Cases *)
  "lr_id4" >:: (fun _ -> assert_equal 17 (map_l_to_r rotor_I_wiring 'E' 4));
  "lr_id5" >:: (fun _ -> assert_equal 14 (map_l_to_r rotor_III_wiring 'C' 6));


  (* Test Cases provided by writeup *)
  "rl_5" >:: (fun _ -> assert_equal 14 (map_l_to_r rotor_I_wiring 'F' 10));

  (* Other test cases (not part of the sweep) *)
  "lr_ex3" >:: (fun _ -> assert_equal 20 (map_l_to_r rotor_I_wiring  'A' 0));

  "lr_ex3" >:: (fun _ -> assert_equal 20 (map_l_to_r rotor_I_wiring  'A' 0) ~printer:string_of_int);
]

(*******************************************************************)
(* Tests for Part 3 *)
(*******************************************************************)



let map_refl_tests = [
  (* General Test Cases. No specific complex functionality of function that requires testing *)
  
  (* Other test cases (not part of the sweep) *) 
  "refl_B0" >:: (fun _ -> assert_equal 24 (map_refl refl_B_wiring 0));

  "refl_C0" >:: (fun _ -> assert_equal 21 (map_refl refl_C_wiring 1));
  "refl_C1" >:: (fun _ -> assert_equal 0 (map_refl refl_C_wiring 5));
  "refl_C2" >:: (fun _ -> assert_equal 5 (map_refl refl_C_wiring 0));

  "refl_KD0" >:: (fun _ -> assert_equal 5 (map_refl refl_KD_wiring 10));
  "refl_KD1" >:: (fun _ -> assert_equal 10 (map_refl refl_KD_wiring 5));

  "refl_T0" >:: (fun _ -> assert_equal 1 (map_refl refl_T_wiring 4));
  "refl_T1" >:: (fun _ -> assert_equal 4 (map_refl refl_T_wiring 1));

  (* Other test cases (not part of the sweep) *)
  "refl_B0" >:: (fun _ -> assert_equal 24 (map_refl refl_B_wiring 0));
  "refl_B1" >:: (fun _ -> assert_equal 0 (map_refl refl_B_wiring 24));
  "refl_B2" >:: (fun _ -> assert_equal 3 (map_refl refl_B_wiring 7));
]
(*******************************************************************)
(* Tests for Part 4 *)
(*******************************************************************)
(* Full alphabet mapping used in plug test *)
let full_alpha_mapping = [('A','W'); ('B','H'); ('Q','E'); ('P','D'); ('R','S'); ('U','V'); ('K','X'); ('Z','F'); ('O','M'); ('I','C'); ('N','G'); ('J','L'); ('T','Y')]

let map_plug_tests = [
  (* Checking simple two letter mapping in both direction *)
  "basic0" >:: (fun _ -> assert_equal 'Z' (map_plug [('A','Z')] 'A'));
  "basic1" >:: (fun _ -> assert_equal 'A' (map_plug [('A','Z')] 'Z'));

  (* Checking four letting mapping in both directions *)
  "four0" >:: (fun _ -> assert_equal 'Z' (map_plug [('A','Z'); ('X','Y')] 'A'));
  "four1" >:: (fun _ -> assert_equal 'X' (map_plug [('A','Z'); ('X','Y')] 'Y'));


  (* Testing plugboard using all plugs *)
  "full0" >:: (fun _ -> assert_equal 'N' (map_plug full_alpha_mapping 'G'));
  "full1" >:: (fun _ -> assert_equal 'V' (map_plug full_alpha_mapping 'U'));
  "full2" >:: (fun _ -> assert_equal 'A' (map_plug full_alpha_mapping 'W'));
  "full3" >:: (fun _ -> assert_equal 'Y' (map_plug full_alpha_mapping 'T'));
  
  (* should have tested for valid enteries for each pair to be from A..Z But meh *)
  (* Testing for Invalid plug configiration *)
  "invalidPlugs" >:: (fun _ -> assert_raises (Invalid_argument "Invalid plugs") (fun()->(map_plug [('A','Y'); ('X','Y')] 'Y')) );
  
  (* Other test cases (not part of the sweep) *)
  "plug_empty" >:: (fun _ -> assert_equal 'A' (map_plug [] 'A'));

]
(*******************************************************************)
(* Tests for Part 5 *)
(*******************************************************************)

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

(* let cipher_char_tests = [
  (* TODO: test sweep *) 
  
  (* Other test cases (not part of the sweep) *) 
  "cipher_id_A" >:: (fun _ -> assert_equal 'A' (cipher_char id_config 'A'));

  "cipher_id_Z" >:: (fun _ -> assert_equal 'Z' (cipher_char id_config 'Z'));
  "cipher_ex" >:: (fun _ -> assert_equal 'P' (cipher_char cipher_char_ex_config 'G'));
] *)

let cipher_char_tests = [
  (* Identity config tests *)
  "cipher_id1" >:: (fun _ -> assert_equal 'A' (cipher_char id_config 'A'));
  "cipher_id2" >:: (fun _ -> assert_equal 'D' (cipher_char id_config 'D'));
  "cipher_id3" >:: (fun _ -> assert_equal 'Z' (cipher_char id_config 'Z'));


  (* Example problem cases *)
  "cipher_ex1" >:: (fun _ -> assert_equal 'M' (cipher_char cipher_char_ex_config 'R'));
  "cipher_ex2" >:: (fun _ -> assert_equal 'X' (cipher_char cipher_char_ex_config 'Y'));
  "cipher_ex3" >:: (fun _ -> assert_equal 'E' (cipher_char cipher_char_ex_config 'B'));
  "cipher_ex4" >:: (fun _ -> assert_equal 'O' (cipher_char cipher_char_ex_config 'D') ~printer:(String.make 1) );


  (* Other test cases (not part of the sweep) *)
  "cipher_id" >:: (fun _ -> assert_equal 'A' (cipher_char id_config 'A'));
  "cipher_ex" >:: (fun _ -> assert_equal 'P' (cipher_char cipher_char_ex_config 'G'));
]

(*******************************************************************)
(* Tests for Part 6 *)
(*******************************************************************)

let step_ex_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'K'};
    {rotor = rotor_II;  top_letter = 'D'};
    {rotor = rotor_I;   top_letter = 'O'};
  ];
  plugboard = [];
}

let step_ex_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'K'};
    {rotor = rotor_II;  top_letter = 'D'};
    {rotor = rotor_I;   top_letter = 'P'};
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

let step_ex2_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'W'};
    {rotor = rotor_II;  top_letter = 'F'};
    {rotor = rotor_I;   top_letter = 'S'};
  ];
  plugboard = [];
}

let step_tests = [
  (* TODO: test sweep *)

  (* Other test cases (not part of the sweep) *)
  "step_ex1a" >:: (fun _ -> assert_equal step_ex_config' (step step_ex_config));
  "step_ex2a" >:: (fun _ -> assert_equal step_ex2_config' (step step_ex2_config));

]
(*******************************************************************)
(* Tests for Part 7 *)
(*******************************************************************)

let cipher_ex_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'F'};
    {rotor = rotor_II;  top_letter = 'U'};
    {rotor = rotor_III; top_letter = 'N'};
  ];
  plugboard = ['A','Z'];
}

let cipher_tests = [
  (* TODO: test sweep *) 
  
  (* Other test cases (not part of the sweep) *) 
  "ex" >:: (fun _ -> assert_equal "OCAML" (cipher cipher_ex_config "YNGXQ"));
  "id0" >:: (fun _ -> assert_equal "ABCDEFGHIJKLMNOPQRSTUVWXYZ" (cipher id_config "ABCDEFGHIJKLMNOPQRSTUVWXYZ"));

]

let tests =
  "test suite for A1"  >::: List.flatten [
    index_tests;
    map_rl_tests;
    map_lr_tests;
    wiring_tests;
    reflector_tests;
    map_refl_tests;
    
    map_plug_tests;
    cipher_char_tests;
    step_tests;
    cipher_tests; 
  ]

let _ = run_test_tt_main tests
