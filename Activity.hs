{-# LANGUAGE TemplateHaskell #-}

module Activity
  ( Activity(..)
   ,getCurrentActivity ) where

import Data.Time.Clock
import Data.Time.Clock.POSIX
import System.IO
import System.Process
import Control.Lens

data Activity = Activity {
                 _classes :: String 
                ,_name    :: String 
                ,_actions :: Integer
                ,_time    :: Integer } deriving (Show, Read)

makeLenses ''Activity

a :: Activity
a = Activity "" "" 0 (0, 0)

p :: [String] -> Activity
p _ = a

getCurrentActivity :: IO Activity
getCurrentActivity = createProcess (proc "xwm" []){ std_out = CreatePipe } >>=
                     \(_, Just h1, _, _) -> hGetContents h1                >>=
                     \s                  -> return $ p $ words s
