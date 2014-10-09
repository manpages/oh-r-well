module Main where

import Activity

main = getCurrentActivity >>= (\x -> putStrLn $ show x)
