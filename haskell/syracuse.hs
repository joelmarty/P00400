-- P00400 coursework: haskell program
-- Syracuse sequence
--
-- Syracuse sequences are sequences which for any n will converge to 1.
-- This program provides an implementation of a Syracuse sequence:
-- for any n where n is:
--      - 1 : the sequence ends (stop condition)
--      - odd : the following number will be n/2
--      - even : the following number will be 3*n+1
--
-- Usage: just launch the program on CLI and follow instructions

main = do   print "Enter a positive number"
            number <- getLine
            if ((readInt number) > 0)
                then do print(listns (getns (readInt number)))
                else do print("Number must be strictly positive!")

readInt :: String->Int
readInt var = read var

getns :: Int->[Int]
getns p = [i | i <- syracuse p]

syracuse :: Int->[Int]
syracuse 1 = [1]
syracuse n | even n = n:syracuse (n `div` 2)
           | otherwise = n:syracuse (3*n +1)

listns [] = ""
listns (head:tail) = show(head) ++ " " ++ listns tail
