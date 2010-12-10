/*
                                     Zebra                                  
This program resolves the zebra enigma:

Five consecutives houses of different colors are inhabited by 5 different mens of different nationalities and professions.
Each one has a different animal and a preffered drink.

We also know that:

1 - The norwegian is in the first house
2 - The inhabitant of the 3rd house drinks milk
3 - The english man lives in the red house
4 - The spanish man has a dog
5 - The japanese is a painter
6 - The italian drinks tea
7 - The inhabitant of the green house drinks coffee
8 - The white house is right of the green one
9 - The carver raises snails
10 - The diplomat lives in the yellow house
11 - The norwegian lives in the blue house
12 - The violonist drinks fruit juice
13 - The doctor has a fox
14 - The diplomat has a horse
*/

same_house(X,[X|_],Y,[Y|_]).
same_house(X,[_|LX],Y,[_|LY]) :- same_house(X,LX,Y,LY).

neighbor(X,[X|_],Y,[_,Y|_]).
neighbor(X,[_,X|_],Y,[Y|_]).
neighbor(X,[_|LX],Y,[_|LY]) :- neighbor(X,LX,Y,LY).

right_neighbor(X,Y,[X,Y|_]).
right_neighbor(X,Y,[_|L]) :- right_neighbor(X,Y,L).

zebra(Color,Nationality,Drink,Animal,Job,HasZebra,DrinksWine) :-
        Color=[_,_,_,_,_],
        Nationality=[norwegian,_,_,_,_],
        Drink=[_,_,milk,_,_],
        Animal=[_,_,_,_,_],
        Job=[_,_,_,_,_],
        same_house(english,Nationality,red,Color),
        same_house(dog,Animal,spanish,Nationality),
        same_house(japanese,Nationality,painter,Job),
        same_house(italian,Nationality,tea,Drink),
        same_house(green,Color,coffee,Drink),
        right_neighbor(white,green,Color),
        same_house(carver,Job,snails,Animal),
        same_house(diplomat,Job,yellow,Color),
        neighbor(norwegian,Nationality,blue,Color),
        same_house(violonist,Job,fruit_juice,Drink),
        neighbor(fox,Animal,doctor,Job),
        neighbor(horse,Animal,diplomat,Job),
        same_house(HasZebra,Nationality,zebra,Animal),
        same_house(DrinksWine,Nationality,wine,Drink). 

%Goal: zebra(Color,Nationality,Drink,Animal,Job,HasZebra,DrinksWine)
