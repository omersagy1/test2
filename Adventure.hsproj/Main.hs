import System.IO
import Parser

scriptFile = "test.txt"

main = 
  readFile scriptFile >>= 
    (\scriptText ->
      putStrLn "Unparsed:" >>
      putStrLn scriptText   >>
      putStrLn "Parsed:"   >>
      putStrLn (show(parseScript scriptText)))
