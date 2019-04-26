module Lists_One.Sols where 

import qualified Data.Map as Map
import Data.Maybe (isNothing)

-- 1 
-- Find the last element of a list
myLast :: [a] -> Maybe a 
myLast = foldr (\x xs -> if null xs then Just x else xs) Nothing 

-- 2 
-- Find the last but one element of a list
sndLast :: [a] -> Maybe a
sndLast xs 
  | length xs < 2 = Nothing 
  | otherwise = Just . last $ init xs

-- unsafe, assuming list size > 1
sndLast' :: [a] -> a 
sndLast' = last . init

-- 3 
-- Find the K'th element of a list. The first element in the list is number 1
kthElem :: [a] -> Int -> Maybe a 
kthElem xs n
  | n > length xs || n < 1 = Nothing 
  | otherwise              = Just . head $ drop (n-1) xs

-- 4
-- Find the number of elements of a list.
length' :: [a] -> Int 
length' = foldr (\_ y -> 1 + y) 0

-- 5
-- Reverse a list 
rev :: [a] -> [a] 
rev = foldr (\x xs -> xs ++ [x]) []

-- or
rev' :: [a] -> [a] 
rev' [] = [] 
rev' xs = last xs : rev (init xs)

-- 6
--  Find out whether a list is a palindrome 
palindrome :: Eq a => [a] -> Bool 
palindrome xs
  | rev xs == xs = True 
  | otherwise    = False

-- 7
-- Flatten a nested list structure 
-- flatten (List [Elem 1, List [Elem 2, List [Elem 3, Elem 4], Elem 5]])
data NestedList a =
    Elem a
  | List [NestedList a]
  deriving Show

flatten :: NestedList a -> [a] 
flatten xs = go xs [] 
  where
    go :: NestedList a -> [a] -> [a]
    go (List []) acc     = acc 
    go (Elem x) acc      = [x]
    go (List (x:xs)) acc = go (List xs) (acc ++ flatten x)

-- 8 
-- Eliminate consecutive duplicates of list elements.
compress :: Eq a => [a] -> [a] 
compress = foldr (\x xs -> x : filter (/= x) xs) []

-- or
compress' :: (Eq a, Ord a) => [a] -> [a] 
compress' xs = go xs Map.empty [] 
  where
    go [] _ acc = acc 
    go (y:ys) mp acc 
      | isNothing $ Map.lookup y mp = go ys (Map.insert y 1 mp) (acc ++ [y])
      | otherwise                   = go ys mp acc

-- 9
-- Pack consecutive duplicates of list elements into sublists.
pack :: Eq a => [a] -> [[a]]
pack [] = [] 
pack xs = go (drop 1 xs) [head xs] [] 
  where 
    go [] prevs acc = append prevs acc 
    go (x:xs) prevs acc 
      | x == head prevs = go xs (x : prevs) acc 
      | otherwise       = go xs [x] (append prevs acc) 

append :: [a] -> [[a]] -> [[a]]
append xs = foldr (:) [xs] 

-- 10
-- encode "aaaabccaadeeee"
-- [(4,'a'),(1,'b'),(2,'c'),(2,'a'),(1,'d'),(4,'e')]
encode :: Eq a => [a] -> [(Int, a)]
encode xs = zip (length <$> pack xs) (head <$> pack xs)

partOneTest :: IO () 
partOneTest = do
    putStrLn "myLast [1,2,3,4]"
    print $ myLast [1,2,3,4]

    putStrLn "sndLast ['a'..'z']"
    print $ sndLast ['a'..'z']

    putStrLn "kthElem \"haskell\" 5"
    print $ kthElem "haskell" 5
    
    putStrLn "myLength [123, 456, 789]"
    print $ length' [123, 456, 789]
    
    putStrLn "myReverse \"A man, a plan, a canal, panama!\""
    print $ rev "A man, a plan, a canal, panama!"
    
    putStrLn "palindrome \"madamimadam\""
    print $ palindrome "madamimadam"

    putStrLn "flatten (List [Elem 1, List [Elem 2, List [Elem 3, Elem 4], Elem 5]])"
    print $ flatten (List [Elem 1, List [Elem 2, List [Elem 3, Elem 4], Elem 5]])

    putStrLn "compress \"aaaabccaadeeee\""
    print $ compress "aaaabccaadeeee"

    putStrLn "pack ['a', 'a', 'a', 'a', 'b', 'c', 'c', 'a', 'a', 'd', 'e', 'e', 'e', 'e']"
    print $ pack ['a', 'a', 'a', 'a', 'b', 'c', 'c', 'a', 'a', 'd', 'e', 'e', 'e', 'e']

    putStrLn "encode \"aaaabccaadeeee\"" 
    print $ encode "aaaabccaadeeee"