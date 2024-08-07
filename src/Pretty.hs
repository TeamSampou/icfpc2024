{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Pretty where

import qualified Data.ByteString.Char8 as B8

import Imports hiding (And, ap)
import Expr

newtype PPString = PPS (Endo String) deriving (Semigroup, Monoid)

pps :: String -> PPString
pps = PPS . Endo . (++)

ppsString :: PPString -> String
ppsString (PPS e) = appEndo e []

instance Show PPString where
  show (PPS e) = show $ appEndo e []

instance IsString PPString where
  fromString = pps

showpp :: Show a => a -> PPString
showpp = pps . show

(<+>) :: PPString -> PPString -> PPString
s1 <+> s2 = s1 <> " " <> s2

unwordspp :: [PPString] -> PPString
unwordspp  []     = mempty
unwordspp (w:ws)  = foldl' (<+>) w ws

-----

pprHaskell :: Expr -> String
pprHaskell = ppsNewline . pprExpr (Cxt PInfix Haskell 0)

pprInfix :: Expr -> String
pprInfix = ppsNewline . pprExpr (Cxt PInfix LangICFP 0)

pprPrefix :: Expr -> String
pprPrefix = ppsNewline . pprExpr (Cxt PPrefix LangICFP 0)

ppsNewline :: PPString -> String
ppsNewline = ppsString . (<> "\n")

data PPFix
  = PInfix
  | PPrefix

data PPOutput
  = Haskell
  | LangICFP

data Cxt =
  Cxt
  { ppFix :: PPFix
  , ppOutput :: PPOutput
  , ppIfIndent :: Int
  }

selectOp :: PPOutput -> p -> p -> p
selectOp ppout op hop = case ppout of
  LangICFP  -> op
  Haskell   -> hop

pprExpr :: Cxt -> Expr -> PPString
pprExpr cx e0 = case toELambdaVars e0 of
  EBool b            -> pprBool (ppOutput cx) b
  EInt i             -> pprNat i
  EStr s             -> pprStr s
  EUnary op e        -> pprUnary cx op e
  EBinary op e1 e2   -> pprBinary cx op e1 e2
  EIf e1 e2 e3       -> pprIf cx e1 e2 e3
  ELambda v e        -> pprLambda cx v e
  ELambdaVars vs e   -> pprLambdaVars cx vs e
  ELet bs e          -> pprLet cx bs e
  EVar v             -> pprVar v

pprBool :: PPOutput -> Bool -> PPString
pprBool ppout True   = selectOp ppout  "true"  "True"
pprBool ppout False  = selectOp ppout  "false" "False"

pprNat :: Integer -> PPString
pprNat = showpp

pprStr :: ByteString -> PPString
pprStr = dquote . pps . B8.unpack

pprUnary :: Cxt -> UOp -> Expr -> PPString
pprUnary cx u e = pprUOp (ppOutput cx) u <+> parenExpr cx e

pprUOp :: PPOutput -> UOp -> PPString
pprUOp ppout u = case u of
  Neg       -> selOp  "-"  "-"
  Not       -> selOp  "!"  "not"
  StrToInt  -> selOp  "str-to-int"  "strToInt"
  IntToStr  -> selOp  "int-to-str"  "intToStr"
  where selOp = selectOp ppout

pprBinary :: Cxt -> BinOp -> Expr -> Expr -> PPString
pprBinary pf op e1 e2 = pprBOp pf op (parenExpr pf e1) (parenExpr pf e2)

pprBOp :: Cxt -> BinOp -> PPString -> PPString -> PPString
pprBOp Cxt{ppFix,ppOutput} b = case b of
  Add     ->  opInfix  "+"  "+"
  Sub     ->  opInfix  "-"  "-"
  Mult    ->  opInfix  "*"  "*"
  -- Quot    ->  opInfix  "/"
  Div     ->  opInfix  "/"  "`quot`"
  -- Rem     ->  "%"
  Mod     ->  opInfix  "%"  "`rem`"
  Lt      ->  opInfix  "<"  "<"
  Gt      ->  opInfix  ">"  ">"
  Eql     ->  opInfix  "="  "=="
  Or      ->  opInfix  "|"  "||"
  And     ->  opInfix  "&"  "&&"
  Concat  ->  opInfix  "."  "<>"
  Take    ->  opPrefix "take" "take"
  Drop    ->  opPrefix "drop" "drop"
  Apply   ->  apply
  ApplyLazy   ->  apply
  ApplyEager  ->  \x y -> x <+> "$!" <+> y
  where
    opInfix  op hop = case ppFix of
      PInfix   -> ppInfix (selOp op hop)
      PPrefix  -> ppPrefix (selOp op $ hPrefix hop)
    opPrefix op hop = ppPrefix (selOp op hop)
    selOp = selectOp ppOutput
    hPrefix op
      | backquoted  = fromString $ reverse opr
      | otherwise   = op
      where backquoted = hd1 == "`" && tl1 == "`"
            (hd1, opx) = splitAt 1 (ppsString op)
            (tl1, opr) = splitAt 1 (reverse opx)

    ppInfix   op x y = x <+> op <+> y
    ppPrefix  op x y = op <+> x <+> y

    apply x y = x <+> y

pprIf :: Cxt -> Expr -> Expr -> Expr -> PPString
-- pprIf pf e1 e2 e3 = "if" <+> parenExpr pf e1 <+> parenExpr pf e2 <+> parenExpr pf e3
pprIf cx@Cxt{ppIfIndent} e1 e2 e3 =
  "\n" <> indent <> "if" <+> pprExpr cx' e1     <>
  "\n" <> indent <> "then" <+>  pprExpr cx' e2  <>
  "\n" <> indent <> "else" <+>  pprExpr cx' e3  <>
  "\n"
  where cx' = cx{ppIfIndent = succ ppIfIndent}
        indent = pps $ replicate ppIfIndent ' '

pprLambda :: Cxt -> Var -> Expr -> PPString
pprLambda cx v e = pprLambdaVars cx [v] e

pprLambdaVars :: Cxt -> [Var] -> Expr -> PPString
pprLambdaVars cx vs e = selectOp (ppOutput cx) "λ" "\\" <+> unwordspp (map pprVar vs) <+> "->" <+> pprExpr cx e

pprLet :: Cxt -> [Binding ByteString] -> Expr -> PPString
pprLet cx bs e2 =
  "\n" <>
  foldr (<>) (pprExpr cx e2)
  [ indent <> "let" <+> pprBan ap <> pprVar v <+> "=" <+> pprExpr cx e1 <+> "in\n" | B ap v e1 <- bs ]
  where indent = pps $ replicate (ppIfIndent cx) ' '

pprBan :: IsString a => BinOp -> a
pprBan ApplyEager  = "!"
pprBan _           = ""

pprVar :: Var -> PPString
pprVar v = "v" <> showpp v

-----

parenExpr :: Cxt -> Expr -> PPString
parenExpr cx e
  | literal e  = pprExpr cx e
  | otherwise  = paren (pprExpr cx e)

literal :: Expr -> Bool
literal e = case e of
  EBool {}  -> True
  EInt  {}  -> True
  EStr  {}  -> True
  EVar  {}  -> True
  _         -> False

paren :: PPString -> PPString
paren s = "(" <> s <> ")"

dquote :: PPString -> PPString
dquote s = "\"" <> s <> "\""

-----

_ltestInfix :: String
_ltestInfix = pprInfix _languageTestExpr

_ltestPrefix :: String
_ltestPrefix = pprPrefix _languageTestExpr

_languageTestExpr :: Expr
_languageTestExpr = EIf (EBinary Eql (EBinary Apply (EBinary Apply (EBinary Apply (EBinary Apply (ELambda 3 (ELambda 3 (ELambda 3 (ELambda 2 (EVar 3))))) (EInt 1)) (EInt 2)) (EInt 3)) (EInt 4)) (EInt 3)) (EIf (EBinary Eql (EBinary Apply (ELambda 3 (EVar 3)) (EInt 10)) (EInt 10)) (EIf (EBinary Eql (EBinary Drop (EInt 3) (EStr "test")) (EStr "t")) (EIf (EBinary Eql (EBinary Take (EInt 3) (EStr "test")) (EStr "tes")) (EIf (EBinary Eql (EBinary Concat (EStr "te") (EStr "st")) (EStr "test")) (EIf (EUnary Not (EBinary And (EBool True) (EBool False))) (EIf (EBinary And (EBool True) (EBool True)) (EIf (EUnary Not (EBinary Or (EBool False) (EBool False))) (EIf (EBinary Or (EBool False) (EBool True)) (EIf (EBinary Lt (EUnary Neg (EInt 3)) (EUnary Neg (EInt 2))) (EIf (EBinary Gt (EInt 3) (EInt 2)) (EIf (EBinary Eql (EUnary Neg (EInt 1)) (EBinary Mod (EUnary Neg (EInt 3)) (EInt 2))) (EIf (EBinary Eql (EInt 1) (EBinary Mod (EInt 7) (EInt 3))) (EIf (EBinary Eql (EUnary Neg (EInt 1)) (EBinary Div (EUnary Neg (EInt 3)) (EInt 2))) (EIf (EBinary Eql (EInt 2) (EBinary Div (EInt 7) (EInt 3))) (EIf (EBinary Eql (EInt 6) (EBinary Mult (EInt 2) (EInt 3))) (EIf (EBinary Eql (EInt 3) (EBinary Add (EInt 1) (EInt 2))) (EIf (EBinary Eql (EUnary IntToStr (EInt 15818151)) (EStr "test")) (EIf (EBinary Eql (EUnary StrToInt (EStr "test")) (EInt 15818151)) (EIf (EUnary Not (EBool False)) (EIf (EBinary Eql (EUnary Neg (EInt 3)) (EBinary Sub (EInt 2) (EInt 5))) (EIf (EBinary Eql (EInt 3) (EBinary Sub (EInt 5) (EInt 2))) (EIf (EBinary Eql (EStr "test") (EStr "test")) (EIf (EBinary Eql (EBool False) (EBool False)) (EIf (EBinary Eql (EInt 3) (EInt 3)) (EIf (EBool True) (EBinary Concat (EBinary Concat (EStr "Self-check OK, send `solve language_test ") (EUnary IntToStr (EBinary Add (EInt 2) (EBinary Mult (EInt 311) (EInt 124753942619))))) (EStr "` to claim points for it")) (EStr "if is not correct")) (EStr "binary = is not correct")) (EStr "binary = is not correct")) (EStr "binary = is not correct")) (EStr "binary - is not correct")) (EStr "unary - is not correct")) (EStr "unary ! is not correct")) (EStr "unary # is not correct")) (EStr "unary $ is not correct")) (EStr "binary + is not correct")) (EStr "binary * is not correct")) (EStr "binary / is not correct")) (EStr "binary / is not correct")) (EStr "binary % is not correct")) (EStr "binary % is not correct")) (EStr "binary > is not correct")) (EStr "binary < is not correct")) (EStr "binary | is not correct")) (EStr "binary | is not correct")) (EStr "binary & is not correct")) (EStr "binary & is not correct")) (EStr "binary . is not correct")) (EStr "binary T is not correct")) (EStr "binary D is not correct")) (EStr "application is not correct")) (EStr "application is not correct")
