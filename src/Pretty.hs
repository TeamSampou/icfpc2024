{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Pretty where

import qualified Data.ByteString.Char8 as B8

import Imports hiding (And)
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

-----

pprInfix :: Expr -> String
pprInfix = ppsString . pprExpr PInfix

pprPrefix :: Expr -> String
pprPrefix = ppsString . pprExpr PInfix

data PprFix
  = PInfix
  | PPrefix

pprExpr :: PprFix -> Expr -> PPString
pprExpr pf e0 = case e0 of
  EBool b            -> pprBool b
  EInt i             -> pprNat i
  EStr s             -> pprStr s
  EUnary op e        -> pprUnary pf op e
  EBinary op e1 e2   -> pprBinary pf op e1 e2
  EIf e1 e2 e3       -> pprIf pf e1 e2 e3
  ELambda v e        -> pprLambda pf v e
  EVar v             -> pprVar v

pprBool :: Bool -> PPString
pprBool True  = "true"
pprBool False = "false"

pprNat :: Integer -> PPString
pprNat = showpp

pprStr :: ByteString -> PPString
pprStr = dquote . pps . B8.unpack

pprUnary :: PprFix -> UOp -> Expr -> PPString
pprUnary pf u e = pprUOp u <+> parenExpr pf e

pprUOp :: UOp -> PPString
pprUOp u = case u of
  Neg       -> "-"
  Not       -> "!"
  StrToInt  -> "str-to-int"
  IntToStr  -> "int-to-str"

pprBinary :: PprFix -> BinOp -> Expr -> Expr -> PPString
pprBinary pf op e1 e2 = pprBOp pf op (parenExpr pf e1) (parenExpr pf e2)

pprBOp :: PprFix -> BinOp -> PPString -> PPString -> PPString
pprBOp pprFix b = case b of
  Add     ->  opInfix "+"
  Sub     ->  opInfix "-"
  Mult    ->  opInfix "*"
  -- Quot    ->  opInfix "/"
  Div     ->  opInfix "/"
  -- Rem     ->  "%"
  Mod     ->  opInfix "%"
  Lt      ->  opInfix "<"
  Gt      ->  opInfix ">"
  Eql     ->  opInfix "="
  Or      ->  opInfix "|"
  And     ->  opInfix "&"
  Concat  ->  opInfix "."
  Take    ->  opPrefix "take"
  Drop    ->  opPrefix "drop"
  Apply   ->  apply
  where
    opInfix  op = case pprFix of
      PInfix   -> pprInfix op
      PPrefix  -> pprPrefix op
    opPrefix op = pprPrefix op
    apply x y = x <+> y

    pprInfix   op x y = x <+> op <+> y
    pprPrefix  op x y = op <+> x <+> y

pprIf :: PprFix -> Expr -> Expr -> Expr -> PPString
pprIf pf e1 e2 e3 = "if" <+> parenExpr pf e1 <+> parenExpr pf e2 <+> parenExpr pf e3

pprLambda :: PprFix -> Var -> Expr -> PPString
pprLambda pf v e = "λ" <+> pprVar v <+> "->" <+> pprExpr pf e

pprVar :: Var -> PPString
pprVar v = "v" <> showpp v

-----

parenExpr :: PprFix -> Expr -> PPString
parenExpr pf e
  | literal e  = pprExpr pf e
  | otherwise  = paren (pprExpr pf e)

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

(<+>) :: PPString -> PPString -> PPString
s1 <+> s2 = s1 <> " " <> s2

-----

_ltestInfix :: String
_ltestInfix = pprInfix _languageTestExpr

_ltestPrefix :: String
_ltestPrefix = pprPrefix _languageTestExpr

_languageTestExpr :: Expr
_languageTestExpr = EIf (EBinary Eql (EBinary Apply (EBinary Apply (EBinary Apply (EBinary Apply (ELambda 3 (ELambda 3 (ELambda 3 (ELambda 2 (EVar 3))))) (EInt 1)) (EInt 2)) (EInt 3)) (EInt 4)) (EInt 3)) (EIf (EBinary Eql (EBinary Apply (ELambda 3 (EVar 3)) (EInt 10)) (EInt 10)) (EIf (EBinary Eql (EBinary Drop (EInt 3) (EStr "test")) (EStr "t")) (EIf (EBinary Eql (EBinary Take (EInt 3) (EStr "test")) (EStr "tes")) (EIf (EBinary Eql (EBinary Concat (EStr "te") (EStr "st")) (EStr "test")) (EIf (EUnary Not (EBinary And (EBool True) (EBool False))) (EIf (EBinary And (EBool True) (EBool True)) (EIf (EUnary Not (EBinary Or (EBool False) (EBool False))) (EIf (EBinary Or (EBool False) (EBool True)) (EIf (EBinary Lt (EUnary Neg (EInt 3)) (EUnary Neg (EInt 2))) (EIf (EBinary Gt (EInt 3) (EInt 2)) (EIf (EBinary Eql (EUnary Neg (EInt 1)) (EBinary Mod (EUnary Neg (EInt 3)) (EInt 2))) (EIf (EBinary Eql (EInt 1) (EBinary Mod (EInt 7) (EInt 3))) (EIf (EBinary Eql (EUnary Neg (EInt 1)) (EBinary Div (EUnary Neg (EInt 3)) (EInt 2))) (EIf (EBinary Eql (EInt 2) (EBinary Div (EInt 7) (EInt 3))) (EIf (EBinary Eql (EInt 6) (EBinary Mult (EInt 2) (EInt 3))) (EIf (EBinary Eql (EInt 3) (EBinary Add (EInt 1) (EInt 2))) (EIf (EBinary Eql (EUnary IntToStr (EInt 15818151)) (EStr "test")) (EIf (EBinary Eql (EUnary StrToInt (EStr "test")) (EInt 15818151)) (EIf (EUnary Not (EBool False)) (EIf (EBinary Eql (EUnary Neg (EInt 3)) (EBinary Sub (EInt 2) (EInt 5))) (EIf (EBinary Eql (EInt 3) (EBinary Sub (EInt 5) (EInt 2))) (EIf (EBinary Eql (EStr "test") (EStr "test")) (EIf (EBinary Eql (EBool False) (EBool False)) (EIf (EBinary Eql (EInt 3) (EInt 3)) (EIf (EBool True) (EBinary Concat (EBinary Concat (EStr "Self-check OK, send `solve language_test ") (EUnary IntToStr (EBinary Add (EInt 2) (EBinary Mult (EInt 311) (EInt 124753942619))))) (EStr "` to claim points for it")) (EStr "if is not correct")) (EStr "binary = is not correct")) (EStr "binary = is not correct")) (EStr "binary = is not correct")) (EStr "binary - is not correct")) (EStr "unary - is not correct")) (EStr "unary ! is not correct")) (EStr "unary # is not correct")) (EStr "unary $ is not correct")) (EStr "binary + is not correct")) (EStr "binary * is not correct")) (EStr "binary / is not correct")) (EStr "binary / is not correct")) (EStr "binary % is not correct")) (EStr "binary % is not correct")) (EStr "binary > is not correct")) (EStr "binary < is not correct")) (EStr "binary | is not correct")) (EStr "binary | is not correct")) (EStr "binary & is not correct")) (EStr "binary & is not correct")) (EStr "binary . is not correct")) (EStr "binary T is not correct")) (EStr "binary D is not correct")) (EStr "application is not correct")) (EStr "application is not correct")
