
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
