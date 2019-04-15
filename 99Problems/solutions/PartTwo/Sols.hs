module PartTwo.Sols where 

import PartOne.Sols

-- 11
-- encodeModified "aaaabccaadeeee"
-- [Multiple 4 'a',Single 'b',Multiple 2 'c', Multiple 2 'a',Single 'd',Multiple 4 'e']

data Encode a =
    Single a 
  | Multiple Int a
  deriving Show 

encodeMod :: Eq a => [a] -> [Encode a] 
encodeMod xs = enc <$> pack xs

enc :: [a] -> Encode a 
enc xs 
  | length xs > 1 = Multiple (length xs) (head xs)
  | otherwise     = Single (head xs)

-- 12
-- decodeModified [Multiple 4 'a',Single 'b',Multiple 2 'c', Multiple 2 'a',Single 'd',Multiple 4 'e']
-- "aaaabccaadeeee"

decodeMod :: [Encode a] -> [a] 
decodeMod = concatMap decode 

decode :: Encode a -> [a]
decode (Multiple n x) = replicate n x
decode (Single x) = [x]

-- 13 
encodeDirect :: Eq a => [a] -> [Encode a] 
encodeDirect [] = []
encodeDirect xs = go xs (head xs) 0 [] 
  where 
    go [] prev count acc = app prev count acc 
    go (x:xs) prev count acc 
      | x == prev  = go xs prev (count+1) acc
      | count == 1 = go xs x 1 (acc ++ [Single prev])
      | otherwise  = go xs x 1 (acc ++ [Multiple count prev])

app :: a -> Int -> [Encode a] -> [Encode a]
app p c a
   | c == 1    = a ++ [Single p]
   | otherwise = a ++ [Multiple c p]

--------------------

partTwoTest :: IO () 
partTwoTest = do
    putStrLn "encodeModified \"aaaabccaadeeee\""
    print $ encodeMod "aaaabccaadeeee"

    putStrLn "decodeModified [Multiple 4 'a',Single 'b',Multiple 2 'c', Multiple 2 'a',Single 'd',Multiple 4 'e']"
    print $ decodeMod [Multiple 4 'a',Single 'b',Multiple 2 'c', Multiple 2 'a',Single 'd',Multiple 4 'e']
