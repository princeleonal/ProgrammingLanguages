(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
   string), then you avoid several of the functions in problem 1 having
   polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
    s1 = s2

(* 
 * put your solutions for problem 1 here 
 *)

(* (a) Write a function all_except_option, which takes a string and a string list. Return NONE if thestring is not in the list,
   else return SOME lst where lst is identical to the argument list except the stringis not in it. You may assume the string is 
   in the list at most once. Use same_string, provided to you,to compare strings. Sample solution is around 8 lines. *)
fun all_except_option(str, xs) = 
    let 
        fun two_lists(current_list, previous_list) = 
          case current_list
            of [] => NONE
            | x::xs' => if same_string(str, x)
                        then SOME (previous_list@xs')
                        else two_lists(xs', previous_list@[x])
    in
      two_lists(xs, [])
    end

(* (b) Write a function get_substitutions1, which takes a string list list (a list of list of strings, thesubstitutions)
 and a string s and returns a string list. The result has all the strings that are insome list in substitutions that also has s, 
 but s itself should not be in the result. Example:get_substitutions1([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],"Fred")
 (* answer: ["Fredrick","Freddie","F"] *)Assume each list in substitutions has no repeats.
 The result will have repeats if s and another string areboth in more than one list in substitutions.
 Example:get_substitutions1([["Fred","Fredrick"],["Jeff","Jeffrey"],["Geoff","Jeff","Jeffrey"]],"Jeff")
 (* answer: ["Jeffrey","Geoff","Jeffrey"] *)  *)
fun get_substitutions1(xss, str) =
  let
    fun track_subs(str, xss, list_add) =
      case xss
        of [] => list_add
        | xs::xss' => case all_except_option(str, xs)
          of NONE => track_subs(str, xss', list_add)
          | SOME x => track_subs(str, xss',list_add@x)
  in
    track_subs(str, xss, [])
  end

(* (c) Write a function get_substitutions2, which is like get_substitutions1 except it uses a tail-recursivelocal helper function. 
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ~~ LOL! I'm already did it :D ~~ 
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*)
fun get_substitutions2(xss, str) = get_substitutions1(xss, str)

(* (d) Write a function similar_names, which takes a string list list of substitutions (as in parts (b) and(c)) and a full name 
of type {first:string,middle:string,last:string} and returns a list of fullnames (type {first:string,middle:string,last:string} list). 
The result is all the full names youcan produce by substituting for the first name (and only the first name) 
using substitutions and parts (b)or (c). The answer should begin with the original name (then have 0 or more other names). 
Example:similar_names([["Fred","Fredrick"],["Elizabeth","Betty"],["Freddie","Fred","F"]],{first="Fred", middle="W", last="Smith"}) 
answer: [{first="Fred", last="Smith", middle="W"},
         {first="Fredrick", last="Smith", middle="W"},
         {first="Freddie", last="Smith", middle="W"},
         {first="F", last="Smith", middle="W"}] *)
fun similar_names(xss, {first=f, middle=m, last=l}) = 
    let 
      val other_firsts = f::get_substitutions1(xss, f)
    in
      let
      fun get_answer(sub_firsts, names) =
        case sub_firsts of
          [] => names
        | x::xs' => get_answer(xs', names@[{first = x, middle=m, last=l}])
      in
      get_answer(other_firsts, [])
    end
  end

(* =================================================================================== *)

(* you may assume that Num is always used with values 2, 3, ..., 10
   though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int 
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw 

exception IllegalMove

(*
 * put your solutions for problem 2 here 
 *)

