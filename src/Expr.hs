{-# LANGUAGE OverloadedStrings #-}
module Expr
  ( Expr (..)
  , Var
  , UOp (..)
  , BinOp (..)
  , Token
  , encode
  , encodeBase94
  ) where

import Data.ByteString.Char8 (ByteString)
import qualified Data.ByteString.Char8 as BS
import Data.List (unfoldr)


data Expr
  = EBool !Bool
  | EInt !Integer
  | EUnary !UOp Expr
  | EBinary !BinOp Expr Expr
  | EIf Expr !Expr Expr
  | ELambda Var Expr
  | EVar Var


type Var = Int


data UOp
  = Neg
  | Not
  | StrToInt
  | IntToStr
  deriving (Eq, Ord, Enum, Show)


data BinOp
  = Add
  | Sub
  | Mult
  | Div
  | Mod
  | Lt
  | Gt
  | Eql
  | Or
  | And
  | Concat
  | Take
  | Drop
  | Apply
  deriving (Eq, Ord, Enum, Show)


type Token = ByteString


encode :: Expr -> [Token]
encode (EBool b) = [encodeBool b]
encode (EInt n) = [encodeNat n]
encode (EUnary op e) = encodeUOp op : encode e
encode (EBinary op e1 e2) = encodeBinOp op : encode e1 ++ encode e2
encode (EIf e1 e2 e3) = tokenIf : encode e1 ++ encode e2 ++ encode e3
encode (ELambda x e) = encodeLambda x : encode e
encode (EVar x) = [encodeVar x]


encodeBool :: Bool -> Token
encodeBool True = "T"
encodeBool False = "F"


encodeNat :: Integer -> Token
encodeNat n = "I" <> encodeBase94 n


encodeUOp :: UOp -> Token
encodeUOp Neg = "-"
encodeUOp Not = "!"
encodeUOp StrToInt = "#"
encodeUOp IntToStr = "$"


encodeBinOp :: BinOp -> Token
encodeBinOp Add    = "+"
encodeBinOp Sub    = "-"
encodeBinOp Mult   = "*"
encodeBinOp Div    = "/"
encodeBinOp Mod    = "%"
encodeBinOp Lt     = "<"
encodeBinOp Gt     = ">"
encodeBinOp Eql    = "="
encodeBinOp Or     = "|"
encodeBinOp And    = "&"
encodeBinOp Concat = "."
encodeBinOp Take   = "T"
encodeBinOp Drop   = "D"
encodeBinOp Apply  = "$"


tokenIf :: Token
tokenIf = "?"


encodeLambda :: Int -> Token
encodeLambda n = "L" <> encodeBase94 n


encodeVar :: Int -> Token
encodeVar n = "v" <> encodeBase94 n


encodeBase94 :: Integral a => a -> ByteString
encodeBase94 n | n < 0 = undefined
encodeBase94 0 = "!"
encodeBase94 n = BS.pack (reverse (unfoldr f n))
  where
     f 0 = Nothing
     f x =
       case x `divMod` 94 of
         (q, r) -> Just (toEnum (fromIntegral (r + 33)), q)