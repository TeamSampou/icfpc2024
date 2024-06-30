module ThreeD where

import qualified Data.Set as Set
import qualified Data.HashMap.Strict as Hash
import Data.Hashable
import Control.Arrow
import Data.Maybe
import Data.Void (Void)

data Direction = L | R | U | D deriving (Show, Eq)
data Arith = Add | Sub | Mul | Quot | Rem deriving (Show, Eq)
data Logic = Eql | Neq deriving (Show, Eq)

data Op3D = Move Direction
          | Calc Arith
          | Judge Logic
          | Warp
          -- | Submit -- ??
          deriving (Show, Eq)

calc :: Arith -> Int -> Int -> Int
calc Add  = (+)
calc Sub  = (-)
calc Mul  = (*)
calc Quot = div
calc Rem  = rem

judge :: Logic -> Int -> Int -> Bool
judge Eql = (==)
judge Neq = (/=)

type Cell = (Int, Int)
type Grid = Hash.HashMap Cell Place
type Tick = Int
type Space = [(Tick, Grid)]

data Place = Operator Op3D
           | Number   Int
           | Var Char  -- 'A' and 'B' only
           deriving (Show, Eq)

instance Hashable Place where
  hashWithSalt = defaultHashWithSalt


isOperator :: Place -> Bool
isOperator (Operator _) = True
isOperator _            = False

operators :: Grid -> Hash.HashMap Cell Place
operators = Hash.filter isOperator

-- 各オペレータの読み取り対象セル
sources :: Op3D -> Cell -> [Cell]
sources (Move L) (x,y) = [(x+1, y  )] -- <
sources (Move R) (x,y) = [(x-1, y  )] -- >
sources (Move U) (x,y) = [(x,   y+1)] -- ^
sources (Move D) (x,y) = [(x,   y-1)] -- v
sources (Calc o) (x,y) = [arg1, arg2] -- +, -, *, /, %
  where arg1 = (x-1, y  )
        arg2 = (x,   y-1)
sources (Judge o) (x,y) = [arg1, arg2] -- =, #
  where arg1 = (x-1, y  )
        arg2 = (x,   y-1)
sources Warp     (x,y) = [v,dx,dy,dt] -- @ v は取り出しやすいように先頭に
  where dx = (x-1, y  )
        dy = (x+1, y  )
        dt = (x,   y+1)
        v  = (x,   y-1)
sources _        _     = [] -- S, Var, Void


getSourceCells :: Grid -> (Cell, Place) -> [(Cell, Place)]
getSourceCells g (p, Operator o)
  = mapMaybe sequenceA [ (c, t) | c <- sources o p, let t = Hash.lookup c g]
getSourceCells _ _ = []


-- 各オペレータの書き込み対象セル
targets :: Place -> Cell -> [(Cell, Place)] -> [(Cell, Place)]
targets (Operator (Move L)) (x, y) [(_, n)] = [(t, n)]  -- <
  where t = (x-1, y)
targets (Operator (Move R)) (x, y) [(_, n)] = [(t, n)]  -- >
  where t = (x+1, y)
targets (Operator (Move U)) (x, y) [(_, n)] = [(t, n)]  -- ^
  where t = (x, y-1)
targets (Operator (Move D)) (x, y) [(_, n)] = [(t, n)]  -- v
  where t = (x, y+1)
targets (Operator (Calc op)) (x, y) [(_, Number a), (_, Number b)]
  = [(ret1, v),(ret2, v)]  -- +, -, *, /, %
  where ret1 = (x+1, y)
        ret2 = (x, y+1)
        v = Number $ calc op a b
targets (Operator (Judge op)) (x, y) [(_, Number a), (_, Number b)]
  = mapMaybe sequenceA [(ret1, v),(ret2, v)]  -- =, #
  where ret1 = (x+1, y)
        ret2 = (x, y+1)
        v = if judge op a b then Just (Number a) else Nothing
targets (Operator Warp) (x, y) [(_, v), (_, Number dx), (_, Number dy), dt]
  = [(d, v)] -- @
  where d = (x - dx, y - dy)

data Updatable = Del (Cell, Place)
               | Upd (Cell, Place)
               deriving (Show, Eq)

updatables :: Grid -> [Updatable]
updatables g = foldr phi [] ops
  where
    phi :: (Cell, Place) -> [Updatable] -> [Updatable]
    phi cell@(c, p@(Operator _)) acc = xs ++ acc
      where
        xs :: [Updatable]
        xs = (Del <$> ss) <> (Upd <$> ts)
        ss :: [(Cell, Place)]
        ss = getSourceCells g cell
        ts :: [(Cell, Place)]
        ts = targets p c ss
    ops :: [(Cell, Place)]
    ops = Hash.toList $ operators g

-- | TODO: conflict の検出はまだ。Submit があるのでちょっとややこしい
step :: Grid -> Grid
step g = undefined

               
{- | Grid Layout
  0 1 2
0 . y .
1 x - .
2 . . .
-}
sample :: Grid
sample = Hash.fromList [ ((0,1), Number 5) -- x
                       , ((1,0), Number 3) -- y
                       , ((1,1), Operator (Calc Sub))
                       ]
