import System.IO
import Parser

storyFile = "test.txt"

main = 
  readFile storyFile >>= 
    (\storyText ->
      putStrLn "Unparsed:" >>
      putStrLn storyText   >>
      putStrLn "Parsed:"   >>
      putStrLn (parse storyText))
