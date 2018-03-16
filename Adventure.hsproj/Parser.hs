module Parser where

-- Data types for the game tree
-- TODO: move this stuff to its own file
-- since it needs to be accessed by the
-- player a well as the parser.
data Narration = Narration { text :: String }
  deriving (Show)


-- Parsing functionality

data Parser a = Parser (String -> [(a, String)])

-- Applies a parser.
parse :: Parser a -> String -> [(a, String)]
parse (Parser p) inp = p inp


instance Functor Parser where
  -- fmap :: (a -> b) -> Parser a -> Parser b
  fmap fn p = Parser (\inp -> case (parse p inp) of
                                [] -> []
                                [(val, rest)] -> [((fn val), rest)])

instance Applicative Parser where
  -- pure :: a -> Parser a
  pure val = Parser (\inp -> [(val, inp)])
  
  -- <*> :: Parser (a -> b) -> Parser a -> Parser b
  pfn <*> px = Parser (\inp -> case (parse pfn inp) of
                                [] -> []
                                -- If the function was lifted with 'pure',
                                -- 'rest' will actually be untouched. See
                                -- the above definition of pure, which just
                                -- passes 'inp' straight through.
                                [(fn, rest)] -> (parse (fmap fn px) rest))

instance Monad Parser where
  
  -- >>= :: Parser a -> (a -> Parser b) -> Parser b
  px >>= fn = Parser (\inp -> case (parse px inp) of
                                [] -> []
                                [(val, rest)] -> (parse (fn val) rest))



unit :: Parser Char
unit = Parser(\inp -> case inp of
                        ""      -> []
                        (x: xs) -> [(x, xs)])

second :: Parser Char
second = unit >>= \x1 ->
         unit >>= \x2 ->
         (pure x2)
         
two :: Parser String
two = unit >>= \x1 ->
      unit >>= \x2 ->
      (pure (x1:x2:[]))


parseScript :: String -> Narration
parseScript = parseNarration

parseNarration :: String -> Narration
parseNarration (x:y:xs) = Narration {text=xs}