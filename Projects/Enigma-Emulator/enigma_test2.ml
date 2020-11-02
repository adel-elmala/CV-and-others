
open OUnit2
(* If you get an "unbound module" error from the line below,
   it's most likely because you have not (re)compiled [enigma.ml]. 
   To do that, run [make build]. *)
open Enigma

(** [make_index_test name input expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output]
    with [index input]. *)
let make_index_test 
    (name : string) 
    (input: char) 
    (expected_output : int) : test = 
  name >:: (fun _ -> 
      (* the [printer] tells OUnit how to convert the output to a string *)
      assert_equal expected_output (index input) ~printer:string_of_int)

(* TODO: you will find it helpful to write functions like [make_index_test]
   for each of the other functions you are testing.  They will keep your
   lists of tests below very readable, and will also help you to avoid
   repeating code. *)

let make_rl_test
    (name : string)
    (wiring : string)
    (top_letter : char)
    (input_pos : int) 
    (expected_output : int): test =
  name >:: (fun _ ->
      assert_equal expected_output (map_r_to_l wiring top_letter input_pos) ~printer:string_of_int)

let make_lr_test
    (name : string)
    (wiring : string)
    (top_letter : char)
    (input_pos : int) 
    (expected_output : int): test =
  name >:: (fun _ ->
      assert_equal expected_output (map_l_to_r wiring top_letter input_pos) ~printer:string_of_int)

let make_refl_test
    (name : string)
    (wiring : string)
    (input_pos : int)
    (expected_output : int): test = 
  name >:: (fun _ ->
      assert_equal expected_output (map_refl wiring input_pos) ~printer:string_of_int)

let make_plug_test
    (name : string)
    (plugs : (char*char) list)
    (c : char)
    (expected_output : char): test = 
  name >:: (fun _ ->
      assert_equal expected_output (map_plug plugs c))

let index_tests = [
  make_index_test "index of A is 0" 'A' 0;
  make_index_test "index of B is 1" 'B' 1;
  make_index_test "index of Z is 26" 'Z' 25;
  (* TODO: add your tests here *)
]

let map_rl_tests = [
  (* TODO: add your tests here *)
  make_rl_test "input_pos to output_pos flow is 0" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 'A' 0 0;
  make_rl_test "input_pos to output_pos flow is 9" "EKMFLGDQVZNTOWYHXUSPAIBRCJ" 'B' 0 9;
  make_rl_test "input_pos to output_pos flow is 1" "BACDEFGHIJKLMNOPQRSTUVWXYZ" 'A' 0 1;
  make_rl_test "input_pos to output_pos flow is 1" "BACDEFGHIJKLMNOPQRSTUVWXYZ" 'B' 1 1;
  make_rl_test "input_pos to output_pos flow is 1" "BACDEFGHIJKLMNOPQRSTUVWXYZ" 'C' 1 1;
  make_rl_test "input_pos to output_pos flow is 17" "BDFHJLCPRTXVZNYEIWGAKMUSQO" 'O' 14 17;
]

let map_lr_tests = [
  (* TODO: add your tests here *)
  make_lr_test "input_pos to output_pos flow is 20" "EKMFLGDQVZNTOWYHXUSPAIBRCJ" 'A' 0 20;
  make_lr_test "input_pos to output_pos flow is 20" "EKMFLGDQVZNTOWYHXUSPAIBRCJ" 'B' 0 21;
  make_lr_test "input_pos to output_pos flow is 14" "EKMFLGDQVZNTOWYHXUSPAIBRCJ" 'F' 10 14;
]

let map_refl_tests = [
  (* TODO: add your tests here *)
  make_refl_test "reflection is letter itself" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 0 0;
  make_refl_test "reflection is letter itself" "ABCDEFGHIJKLMNOPQRSTUVWXYZ" 25 25;
  make_refl_test "reflection is letter itself" "YRUHQSLDPXNGOKMIEBFZCWVJAT" 0 24;
  make_refl_test "reflection is letter itself" "YRUHQSLDPXNGOKMIEBFZCWVJAT" 24 0;
  make_refl_test "reflection is letter itself" "FVPJIAOYEDRZXWGCTKUQSBNMHL" 25 11;
  make_refl_test "reflection is letter itself" "FVPJIAOYEDRZXWGCTKUQSBNMHL" 11 25;
]

let map_plug_tests = [
  (* TODO: add your tests here *)
  make_plug_test "base case" [] 'A' 'A';
  make_plug_test "only one plug" [('X','Q')] 'Q' 'X';
  make_plug_test "thirteen plugs" 
    [('A','B'); ('C','D');('E','F');('G','H');('I','J');('K','L');
     ('M','N');('O','P');('Q','R');('S','T');('U','V');('W','X');('Y','Z');] 
    'X' 'W';
]

let cipher_char_tests = [
  (* TODO: add your tests here *)
]

let step_tests = [
  (* TODO: add your tests here *)
]

let cipher_tests = [
  (* TODO: add your tests here *)
]

let tests =
  "test suite for A1"  >::: List.flatten [
    index_tests;
    map_rl_tests;
    map_lr_tests;
    map_refl_tests;
    map_plug_tests;
    cipher_char_tests;
    step_tests;
    cipher_tests;
  ]

let _ = run_test_tt_main tests
