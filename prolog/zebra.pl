/*
                                     Zebra

This program resolves the zebra puzzle, also known as Einstein's puzzle:

Five consecutives houses of different colors are inhabited by 5 different mens of different nationalities.
Each one has a different animal, a preffered drink and a preferred brand of smokes.

The problem is stated as:

1   There are five houses.
2   The Englishman lives in the red house.
3   The Spaniard owns the dog.
4   Coffee is drunk in the green house.
5   The Ukrainian drinks tea.
6   The green house is immediately to the right of the ivory house.
7   The Old Gold smoker owns snails.
8   Kools are smoked in the yellow house.
9   Milk is drunk in the middle house.
10  The Norwegian lives in the first house.
11  The man who smokes Chesterfields lives in the house next to the man with the fox.
12  Kools are smoked in the house next to the house where the horse is kept.
13  The Lucky Strike smoker drinks orange juice.
14  The Japanese smokes Parliaments.
15  The Norwegian lives next to the blue house.

Execution:
in prolog interpreter, load the file:
?- ['zebra.pl']

and call:
zebra(Color,Nationality,Drink,Animal,Smoke,HasZebra,DrinksWater)

*/

same_house(X,[X|_],Y,[Y|_]).
same_house(X,[_|LX],Y,[_|LY]) :- same_house(X,LX,Y,LY).

neighbor(X,[X|_],Y,[_,Y|_]).
neighbor(X,[_,X|_],Y,[Y|_]).
neighbor(X,[_|LX],Y,[_|LY]) :- neighbor(X,LX,Y,LY).

right_neighbor(X,Y,[X,Y|_]).
right_neighbor(X,Y,[_|L]) :- right_neighbor(X,Y,L).

zebra(Color,Nationality,Drink,Animal,Smoke,HasZebra,DrinksWater) :-
        Color=[_,_,_,_,_],
        Nationality=[norwegian,_,_,_,_], %10
        Drink=[_,_,milk,_,_], %9
        Animal=[_,_,_,_,_],
        Smoke=[_,_,_,_,_],
        same_house(english,Nationality,red,Color), %2
        same_house(dog,Animal,spanish,Nationality), %3
        same_house(green,Color,coffee,Drink), %4
        same_house(ukrainian,Nationality,tea,Drink), %5
        right_neighbor(ivory,green,Color), %6
        same_house(old_gold,Smoke,snails,Animal), %7
        same_house(kools,Smoke,yellow,Color), %8
        neighbor(fox,Animal,chesterfields,Smoke), %11
        same_house(lucky_strike,Smoke,orange_juice,Drink),
        neighbor(horse,Animal,kools,Smoke), %12
        same_house(japanese,Nationality,parliaments,Smoke), %14
        neighbor(norwegian,Nationality,blue,Color), %15
        same_house(HasZebra,Nationality,zebra,Animal),
        same_house(DrinksWater,Nationality,water,Drink). 


