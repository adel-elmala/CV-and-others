open OUnit2
open Enigma

(*******************************************************************)
(* Helper values used throughout this test suite. *)
(*******************************************************************)

let rotor_id_wiring  = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
let rotor_I_wiring   = "EKMFLGDQVZNTOWYHXUSPAIBRCJ"
let rotor_II_wiring  = "AJDKSIRUXBLHWTMCQGZNPYFVOE"
let rotor_III_wiring = "BDFHJLCPRTXVZNYEIWGAKMUSQO"
let refl_B_wiring    = "YRUHQSLDPXNGOKMIEBFZCWVJAT"
let refl_C_wiring    = "FVPJIAOYEDRZXWGCTKUQSBNMHL"
let refl_D_wiring    = "MOWJYPUXNDSRAIBFVLKZGQCHET"
let plugbrd_13 = [('A','Z');('X','Y');('B','W');('C','D');('E','V');('G','F');
                  ('J','H');('I','K');('M','U');('N','T');('P','O');('Q','R');
                  ('S','L')]
let plugbrd_8 = [('T','X');('A','L');('C','O');('M','N');('B','W');('S','Z');
                 ('J','P');('G','K')]
let s = "AJALKJDLVNALEIQRHBNALADFBAAJDHBALEKRALBNAKUENAVNAEKUNBNADKKNENADNAEKJ\
         ANBAEJARKJENAKJENAAJALDKJGAKFNBUTRMDJGKFKDJFNFHDJFKSHQQYEUGVBDKFNFKED\
         JSDKFHJDNFHRJDNFHDKXNDNSKWJDBANAHUBMNIGUKHWSNFNDSNSJDNFMDJSMNFJJEJJQJ\
         AVVDJDJBNFKVJDHEKBNDCKFKEQQOQLBLKJAWLEKEKCNKEFKAEJ"
let ciphered_s = "NHGUVNOKPUCOHWIANNYYEXFKSGLGBRNJBGZUYDYGYYDBZYWCZCOFDTZNHFMM\
                  NOEWSLRJAFHUYRNBOHEKSGWKVHUBETRLJLWPSJFSKYEPHOVMQUMMNTOBKEIJ\
                  TRLWCUQUNZIDDZJLVVDPQDNDRPFRKAHAJKEEXLGQGZBCQEZODDWPEEAMLTNL\
                  GRUAAIDGFZYOYRKTOVTEMPSPLBITUWEOOXWUPTJVMDDQXAYMYGAACSKWTEVV\
                  QDMXIWLYQBEBGMNPI"

(*******************************************************************)
(* Tests for Part 1 *)
(*******************************************************************)

let index_tests = [
  "index A" >:: (fun _ -> assert_equal 0  (index 'A'));
  "index Z" >:: (fun _ -> assert_equal 25 (index 'Z'));
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
  "rl_id0" >:: (fun _ -> assert_equal 0 (map_r_to_l rotor_id_wiring 'A' 0));

  (* Sweep case 2:  this is meant to be a very simple test case that tests if
   *    map_r_to_l executes correctly when the input position is not 0. Instead
   *    of 0, the input position is 1. *)
  "rl_a1" >:: (fun _ -> assert_equal 10 (map_r_to_l rotor_I_wiring 'A' 1));

  (* Sweep case 3:  this is meant to be a simple test case that test if
   *    map_r_to_l executes correctly when the input position is the highest
   *    possible position, i.e. 25. *)
  "rl_end" >:: (fun _ -> assert_equal 9 (map_r_to_l rotor_I_wiring 'A' 25));

  (* Sweep case 4: this tests cases in which there is a negative offset. This
   *   test case also tests map_l_to_r on a different rotor with a different
   *   wiring. *)
  "rl_neg" >:: (fun _ -> assert_equal 17 (map_r_to_l rotor_III_wiring 'O' 14));

  (* Sweep case 5: this tests an extreme case in which the top letter is Z and
   *    the input position is 25 such that larger numbers and a negative offset
   *    are being dealt with. *)
  "rl_extr" >:: (fun _ -> assert_equal 15 (map_r_to_l rotor_II_wiring 'Z' 25));

  (* Other test cases (not part of the sweep) *)
  "rl_ex1" >:: (fun _ -> assert_equal 4 (map_r_to_l rotor_I_wiring  'A' 0));
  "rl_ex2" >:: (fun _ -> assert_equal 9 (map_r_to_l rotor_I_wiring  'B' 0));
]

let map_lr_tests = [
  (* Sweep case 1:  this is meant to be a simple test case that tests if
   *    map_l_to_r executes correctly on a rotor with very simple wiring with
   *    top letter other than 'A'. *)
  "lr_ex4" >:: (fun _ -> assert_equal 21 (map_l_to_r rotor_I_wiring 'B' 0));

  (* Sweep case 2:  this is meant to be a very simple test case that tests if
   *    map_l_to_r executes correctly when the input position is not 0 and the
   *    the top number isn't 'A'. *)
  "lr_b1" >:: (fun _ -> assert_equal 23 (map_l_to_r rotor_I_wiring 'B' 1));

  (* Sweep case 3: this is a common test case that has inputs of top letter and
   *    input position within their corresponding ranges; that is, top letter
   *    and input position are not near the ends of their corresponding ranges.
   *)
  "lr_comm" >:: (fun _ -> assert_equal 14 (map_l_to_r rotor_I_wiring 'F' 10));

  (* Sweep case 4: this tests cases in which there is a negative offset. This
   *    test case also tests map_l_to_r on a different rotor with a different
   *    wiring. *)
  "lr_neg" >:: (fun _ -> assert_equal 18 (map_l_to_r rotor_III_wiring 'O' 14));

  (* Sweep case 5: this tests an extreme case in which the top letter is Z and
   *    the input position is 25 such that larger numbers and a negative offset
   *    are being dealt with. *)
  "lr_extr" >:: (fun _ -> assert_equal 22 (map_l_to_r rotor_II_wiring 'Z' 25));

  (* Other test cases (not part of the sweep) *)
  "lr_ex3" >:: (fun _ -> assert_equal 20 (map_l_to_r rotor_I_wiring 'A' 0));
]

(*******************************************************************)
(* Tests for Part 3 *)
(*******************************************************************)

let map_refl_tests = [
  (* Sweep case 1:  this is a very simple test case that tests if map_refl
   *    executes correctly for a different reflector C other than relflector
   *    B. *)
  "refl_C0" >:: (fun _ -> assert_equal 5 (map_refl refl_C_wiring 0));

  (* Sweep case 2:  this tests if map_refl executes correctly for an input
   *    position other than 0 and within the middle of the reflector's wiring. *)
  "refl_B13" >:: (fun _ -> assert_equal 10 (map_refl refl_B_wiring 13));

  (* Sweep case 3: this tests a reflector with an input position of 25; that is,
   *    the current enters at the last possible position of the reflector. *)
  "refl_C25" >:: (fun _ -> assert_equal 11 (map_refl refl_C_wiring 25));

  (* Sweep case 4: this tests the reflector from the Norway Enigma (aka
   *    Norenigma)! *)
  "refl_D17" >:: (fun _ -> assert_equal 11 (map_refl refl_D_wiring 17));

  (* Sweep case 5: this is a common test case testing the Norenimga. *)
  "refl_D3" >:: (fun _ -> assert_equal 9 (map_refl refl_D_wiring 3));

  (* Other test cases (not part of the sweep) *)
  "refl_B0" >:: (fun _ -> assert_equal 24 (map_refl refl_B_wiring 0));
]

(*******************************************************************)
(* Tests for Part 4 *)
(*******************************************************************)

let map_plug_tests = [
  (* Sweep case 1:  this is a simple test case that tests if map_plug executes
   *    correctly with a full plugboard; that is the plugboard has 13 cables. *)
  "plug_full" >:: (fun _ -> assert_equal 'Z' (map_plug plugbrd_13 'A'));

  (* Sweep case 2:  this tests if map_plug executes correctly for a pair of
   *    characters regardless of the order of the characters. *)
  "plug_order" >:: (fun _ -> assert_equal 'X' (map_plug plugbrd_13 'Y'));

  (* Sweep case 3:  this tests if map_plug executes correctly for a pair of
   *    characters within the middle of the list of 13 pairs of characters. In
   *    other words, that map_plug works correctly for any pair in a plugboard.
   *)
  "plug_btw" >:: (fun _ -> assert_equal 'I' (map_plug plugbrd_13 'K'));

  (* Sweep case 4:  this tests a plugboard that is not full; that is, the
   *    the pluboard does not have 13 cables so not all characters within A...Z
   *    are included in the plugboard. *)
  "plug_not_full" >:: (fun _ -> assert_equal 'C' (map_plug plugbrd_8 'O'));

  (* Sweep case 5:  this tests the case in which the plugboard is not full and
   *    the character inputted is not included in the plugboard. *)
  "plug_DNE" >:: (fun _ -> assert_equal 'Q' (map_plug plugbrd_8 'Q'));

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

let cipher_char_a_config = {
  refl = refl_C_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'J'};
    {rotor = rotor_II;  top_letter = 'Z'};
    {rotor = rotor_III; top_letter = 'C'};
  ];
  plugboard = plugbrd_13;
}

let cipher_char_b_config = {
  refl = refl_D_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'B'};
    {rotor = rotor_II;  top_letter = 'Q'};
    {rotor = rotor_III; top_letter = 'E'};
  ];
  plugboard = plugbrd_8;
}

let cipher_char_tests = [
  (* Sweep case 1: this is a common test case testing a configuration with rotors
   *    with top letters 'A' and an empty plugboard. *)
  "cipher_ex1" >:: (fun _ -> assert_equal 'U' (cipher_char cipher_char_ex_config 'A'));

  (* Sweep case 2: this is a common test case testing a configuration with rotors
   *    with top letters 'A' and an empty plugboard. *)
  "cipher_ex2" >:: (fun _ -> assert_equal 'H' (cipher_char cipher_char_ex_config 'Z'));

  (* Sweep case 3: this tests a configuration with rotors that each have a
   *    different top letter other than 'A' and a full plugboard. *)
  "cipher_a1" >:: (fun _ -> assert_equal 'E' (cipher_char cipher_char_a_config 'K'));

  (* Sweep case 4: this is a common test case testing a configuration with rotors
   *    that each have a different top letter other than 'A' and a full plugboard.
   *)
  "cipher_a2" >:: (fun _ -> assert_equal 'Y' (cipher_char cipher_char_a_config 'S'));

  (* Sweep case 5: this tests a configuration with rotors that each have a
   *    different top letter other than 'A' and a plugboard is not empty but has
   *    less than 13 cables. *)
  "cipher_b1" >:: (fun _ -> assert_equal 'B' (cipher_char cipher_char_b_config 'V'));

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

let step_a_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'D'};
    {rotor = rotor_I;   top_letter = 'P'};
  ];
  plugboard = [];
}

let step_a_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'D'};
    {rotor = rotor_I;   top_letter = 'Q'};
  ];
  plugboard = [];
}

let step_b_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'E'};
    {rotor = rotor_I;   top_letter = 'Q'};
  ];
  plugboard = [];
}

let step_b_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'W'};
    {rotor = rotor_II;  top_letter = 'F'};
    {rotor = rotor_I;   top_letter = 'R'};
  ];
  plugboard = [];
}

let step_c_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'U'};
    {rotor = rotor_II;  top_letter = 'C'};
    {rotor = rotor_I;   top_letter = 'Q'};
  ];
  plugboard = [];
}

let step_c_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'U'};
    {rotor = rotor_II;  top_letter = 'D'};
    {rotor = rotor_I;   top_letter = 'R'};
  ];
  plugboard = [];
}

let step_d_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'S'};
    {rotor = rotor_II;  top_letter = 'E'};
    {rotor = rotor_I;   top_letter = 'A'};
  ];
  plugboard = [];
}

let step_d_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'T'};
    {rotor = rotor_II;  top_letter = 'F'};
    {rotor = rotor_I;   top_letter = 'B'};
  ];
  plugboard = [];
}

let step_e_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'I'};
    {rotor = rotor_I;   top_letter = 'V'};
  ];
  plugboard = [];
}

let step_e_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'I'};
    {rotor = rotor_I;   top_letter = 'W'};
  ];
  plugboard = [];
}

let step_f_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'V'};
    {rotor = rotor_II;  top_letter = 'E'};
    {rotor = rotor_I;   top_letter = 'T'};
  ];
  plugboard = [];
}

let step_f_config' = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_III; top_letter = 'W'};
    {rotor = rotor_II;  top_letter = 'F'};
    {rotor = rotor_I;   top_letter = 'U'};
  ];
  plugboard = [];
}

let step_tests = [
  (* Sweep case 1: this tests a configuration in which for each of the rotors,
   *    the rotor's top letter does not equal the rotor's turnover. *)
  "step_a" >:: (fun _ -> assert_equal step_a_config' (step step_a_config));

  (* Sweep case 2: this tests a configuration in which for each of the rotors,
   *    the rotor's top letter equals the rotor's turnover. *)
  "step_b" >:: (fun _ -> assert_equal step_b_config' (step step_b_config));

  (* Sweep case 3: this tests a configuration in which the rightmost rotor's top
   *    letter equals its turnover. *)
  "step_c" >:: (fun _ -> assert_equal step_c_config' (step step_c_config));

  (* Sweep case 4: this tests a configuration in which the middle rotor's top
   *    letter equals its turnover. *)
  "step_d" >:: (fun _ -> assert_equal step_d_config' (step step_d_config));

  (* Sweep case 5: this tests a configuration in which the leftmost rotor's top
   *    letter equals its turnover. *)
  "step_e" >:: (fun _ -> assert_equal step_e_config' (step step_e_config));

  (* Sweep case 6: this tests a configuration in which the rightmost rotor's top
   *    letter does not equal its turnover but the leftmost rotor and middle
   *    rotor's top letters equal their corresponding turnovers. *)
  "step_f" >:: (fun _ -> assert_equal step_f_config' (step step_f_config));

  (* Other test cases (not part of the sweep) *)
  "step_ex1a" >:: (fun _ -> assert_equal step_ex_config' (step step_ex_config));
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

let cipher_a_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'F'};
    {rotor = rotor_II;  top_letter = 'U'};
    {rotor = rotor_III; top_letter = 'N'};
  ];
  plugboard = plugbrd_13;
}

let cipher_b_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'P'};
    {rotor = rotor_II;  top_letter = 'A'};
    {rotor = rotor_III; top_letter = 'C'};
  ];
  plugboard = plugbrd_8;
}

let cipher_c_config = {
  refl = refl_B_wiring;
  rotors = [
    {rotor = rotor_I;   top_letter = 'K'};
    {rotor = rotor_II;  top_letter = 'I'};
    {rotor = rotor_III; top_letter = 'D'};
  ];
  plugboard = [];
}

let cipher_tests = [
  (*Sweep case 1: this tests a configuration in which the operator inputs no
   *    letters. *)
  "cipher_ex2" >:: (fun _ -> assert_equal "" (cipher cipher_ex_config ""));

  (*Sweep case 2: this is a simple test case that tests a 5-letter input string
   *    different from "YNGXQ". *)
  "cipher_ex2" >:: (fun _ -> assert_equal "NOUNH" (cipher cipher_ex_config "ABCDE"));

  (*Sweep case 3: this tests a configuration with a full plugboard. *)
  "cipher_a" >:: (fun _ -> assert_equal "WRJVL" (cipher cipher_a_config "YNGXQ"));

  (*Sweep case 4: this tests a configuration with a semi-filled plugboard. *)
  "cipher_b_config" >:: (fun _ -> assert_equal "UZWEK" (cipher cipher_b_config "YNGXQ"));

  (*Sweep case 5: this tests a configuration with an empty plugboard. *)
  "cipher_c_config" >:: (fun _ -> assert_equal "VRGCI" (cipher cipher_c_config "ABCDE"));

  (*Sweep case 6: this tests a a configuration in which the string input is the
   *    alphabet--a 26-letter sequence. *)
  "cipher_ex3_config" >:: (fun _ -> assert_equal "NOUNHPZTUQUOTFTHVUPNWHQZEI"
                          (cipher cipher_ex_config "ABCDEFGHIJKLMNOPQRSTUVWXYZ"));

  (*Sweep case 7: this tests a a configuration in which the string input is a
   *    250-plus-letter sequence. *)
  "cipher_ex4_config" >:: (fun _ -> assert_equal ciphered_s
                              (cipher cipher_ex_config s));

  (* Other test cases (not part of the sweep) *)
  "ex" >:: (fun _ -> assert_equal "OCAML" (cipher cipher_ex_config "YNGXQ"));
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