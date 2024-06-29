module SpaceShip
  ( solve
  , solveFile
  , solveNaive
  , solveNaive'
  ) where

import Data.Map.Strict (Map)
import qualified Data.Map.Strict as Map
import Data.Set (Set)
import qualified Data.Set as Set

type Pos = (Int, Int)

type Velocity = (Int, Int)

type State = (Pos, Velocity)

type Problem = [Pos]

solve :: String -> String
solve = solveNaive . parse

solveFile :: FilePath -> IO String
solveFile fname = solve <$> readFile fname

parse :: String -> Problem
parse s = [(x,y) | l <- lines s, not (null l), let [x,y] = map read $ words l]

solveNaive :: Problem -> String
solveNaive prob = map ((moveToChar Map.!) . fst) $ solveNaive' prob

solveNaive' :: Problem -> [(Move, State)]
solveNaive' prob = f ((0,0), (0,0)) [] prob
  where
    f :: State -> [(Move, State)] -> [Pos] -> [(Move, State)]
    f _s hist [] = reverse hist
    f s hist (p:ps) =
      case g p s hist of
        (s', hist') -> f s' hist' ps

    g :: Pos -> State -> [(Move, State)] -> (State, [(Move, State)])
    g t s@(p@(x,y), (vx,vy)) hist
      | p == t = (s, hist)
      | otherwise = g t s' ((move, s') : hist)
      where
        move@(dvx, dvy) = chooseMove s t
        vx' = vx + dvx
        vy' = vy + dvy
        s' = ((x + vx', y + vy'), (vx', vy'))

    chooseMove :: State -> Pos -> Move
    chooseMove ((x,y), (vx,vy)) (tx, ty) = (choose1DMove x vx tx, choose1DMove y vy ty)

    choose1DMove :: Int -> Int -> Int -> Int
    choose1DMove x v target
      | x > target = - choose1DMove (-x) (-v) (-target)
      | otherwise  = h (target - x) v        
     
    h dist v
      -- assume: 0 <= dist
      | dist == 0 = - signum v
      -- assume: 0 < dist
      | v <= 0 = 1
      -- assume: 0 <= v
      | otherwise =
          if (v+1)^(2::Int) <= dist then
            1
          else if v^(2::Int) >= dist then
            -1
          else
            0
            

type Move = (Int, Int)

-- 789
-- 456
-- 123
moveToChar :: Map (Int,Int) Char
moveToChar = Map.fromList
  [ ((-1, 1),  '7'), ((0,1),  '8'), ((1,1), '9')
  , ((-1, 0),  '4'), ((0,0),  '5'), ((1,0), '6')
  , ((-1,-1), '1'), ((0,-1), '2'), ((1,-1), '3')
  ]
