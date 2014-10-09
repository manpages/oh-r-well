{-# LANGUAGE TemplateHaskell #-}

{--
#!/bin/bash  
wnd_focus=$(xdotool getwindowfocus)
wnd_title=$(xprop -id $wnd_focus WM_NAME)
wnd_class=$(xprop -id $wnd_focus WM_CLASS)
echo -ne "${wnd_class}\n${wnd_title}"
--}

{--
# Xwm output example:
WM_CLASS(STRING) = "Navigator", "Firefox"
WM_NAME(STRING) = "acladd screen site:www.gnu.org at DuckDuckGo - Vimperator (Private Browsing)"
# To be parsed to
Activity { _classes = ["Navigator", "Firefox"], _name="acladd..sing)", _actions = ???, _time = !!! }
--}

module Activity
  ( Activity(..)
   ,getCurrentActivity ) where

import Data.Time.Clock
import Data.Time.Clock.POSIX
import System.IO
import System.Process
import Control.Lens

data Activity = Activity {
                 _classes :: [String]
                ,_name    :: String 
                ,_actions :: Integer
                ,_time    :: Integer } deriving (Show, Read)

makeLenses ''Activity

mk_a :: Activity
mk_a = Activity{ _classes = [], _name = "", _actions = 0, _time = 0 }

parse :: [String] -> Activity
parse (s:ss) = parse_do (s:ss) mk_a

parse_do :: [String] -> Activity -> Activity
parse_do [] a = a
parse_do ("WM_CLASS(STRING)":"=":ss) a = parse_classes ss a

parse_classes :: [String] -> Activity -> Activity
parse_classes ("WM_NAME(STRING)":"=":ss) a = parse_name ss a
parse_classes (x:ss) a = parse_classes ss (a & classes %~ (\xs -> x:xs))

parse_name :: [String] -> Activity -> Activity
parse_name [] a = a
parse_name (x:ss) a = parse_name ss (a & name <>~ (" " ++ x))

getCurrentActivity :: IO Activity
getCurrentActivity = createProcess (proc "xwm" []){ std_out = CreatePipe } >>=
                     \(_, Just h1, _, _) -> hGetContents h1                >>=
                     \s                  -> return (parse (words s))
