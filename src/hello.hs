module Main (main) where

main = putStrLn "Hello, World!"

myFoldr :: (a -> b -> b) -> b -> [a] -> b
myFoldr _ b [] = _