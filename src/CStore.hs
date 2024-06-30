
module CStore where

import Control.Concurrent
import qualified Data.ByteString.Char8 as B8
import System.Directory
import System.FilePath

import Imports
import Expr (Expr)
import qualified CommunicateIO as Comm
import qualified CustomParser as Parser

problemsDir :: FilePath
problemsDir = "problems"

---

data EntryType
  = ELang
  | EExpr
  | EOut
  deriving (Eq, Ord)

type FileEntry = (String, EntryType)

feName :: FileEntry -> String
feName = fst

feType :: FileEntry -> EntryType
feType = snd

entryType :: String -> Maybe EntryType
entryType ext = case ext of
  ".lang"  -> Just ELang
  ".expr"  -> Just EExpr
  ".out"   -> Just EOut
  _        -> Nothing

etypeName :: EntryType -> String
etypeName ty = case ty of
  ELang  -> "lang"
  EExpr  -> "expr"
  EOut   -> "out"

---

writeFile' :: String -> String -> IO ()
writeFile' path cont = do
  let dir = takeDirectory path
  createDirectoryIfMissing True dir
  writeFile path cont

---

catalogList :: [String]
catalogList = [ "index", "echo", "language_test", "scoreboard" ]

problemList :: [String]
problemList =
  [ "lambdaman"
  , "spaceship"
  , "3d"
  , "efficiency"
  ]

_lambdamanProblems :: [String]
_lambdamanProblems = [ "lambdaman" <> show n | n <- [1 .. 21 :: Int] ]

_spaceshipProblems :: [String]
_spaceshipProblems = [ "spaceship" <> show n | n <- [1 .. 25 :: Int] ]

_3dProblems :: [String]
_3dProblems = [ "3d" <> show n | n <- [1 .. 12 :: Int] ]

_efficiencyProblems :: [String]
_efficiencyProblems = [ "efficiency" <> show n | n <- [1 .. 14 :: Int] ]

---

storeLangFile :: String -> FilePath -> IO ()
storeLangFile pname path = do
  putStrLn $ "geting " ++ pname ++ " ..."
  lang <- Comm.getLang pname
  putStrLn $ "writing " ++ path ++ " with LAST NEWLINE ..."
  writeFile' (problemsDir </> pname <.> etypeName ELang) (lang <> "\n")
  putStrLn $ "done."

delayedStoreLangList :: Bool -> [String] -> IO ()
delayedStoreLangList overwrite pns =
  mapM_ action pns
  where
    action pname = do
      let path = problemsDir </> pname <.> etypeName ELang
      let write = do
            storeLangFile pname path
            putStrLn "delay .."
            threadDelay (35 * 100 * 1000)
      alreadyExist <- doesFileExist path
      case () of
        () | not alreadyExist  -> write
           | overwrite         -> putStrLn ("already exists, but proceeding with overwrite mode: " ++ pname) *> write
           | otherwise         -> putStrLn ("already exists, skipping: " ++ path)

---

storeLangExpr :: String -> IO ()
storeLangExpr pname = do
  let lpath = problemsDir </> pname <.> etypeName ELang
  let epath = problemsDir </> pname <.> etypeName EExpr
  putStrLn $ "loading " ++ lpath ++ " ..."
  eexpr <- Parser.parseExpr_ <$> B8.readFile lpath
  let write expr = do
        putStrLn $ "writing " ++ epath ++ " ..."
        writeFile epath (show expr <> "\n")
        putStrLn "done."
      skip e = putStrLn $ "parse error: " ++ e ++ ": skipping"
  either skip write eexpr

loadLangExpr :: String -> IO Expr
loadLangExpr pname = do
  let epath = problemsDir </> pname <.> etypeName EExpr
  putStrLn $ "loading " ++ epath ++ " ..."
  readIO =<< readFile epath

---

fileEntry :: FilePath -> Maybe FileEntry
fileEntry = entry . splitExtension
  where entry (nm, ext) = (,) nm <$> entryType ext

getFileEntries :: IO [FileEntry]
getFileEntries = mapMaybe fileEntry <$> listDirectory problemsDir

data Entry =
  Entry
  { name   :: String
  , types  :: [EntryType]
  }

mergeEntry :: [FileEntry] -> [Entry]
mergeEntry = map gentry . groupBy ((==) `on` feName)
  where gentry g@((n,_):_) = Entry n [t | (_, t) <- g]
        gentry        []    = error "mergeEntry: groupBy constraint broken!"

getRecvEntries :: IO [Entry]
getRecvEntries = mergeEntry . sort <$> getFileEntries

listRecvMatrix :: [Entry] -> [String]
listRecvMatrix es = [ unwords ws | ws <- title : hbar : [ entry e | e <- es] ]
  where filled width c s = s ++ replicate (width - length s) c
        nmfill = filled 20
        tyfill = filled 8
        tyCols = [ELang, EExpr, EOut]
        cnum = length tyCols
        title = nmfill ' ' "<name>" : [tyfill ' ' ("<" <> etypeName ty <> ">") | ty <- tyCols]
        hbar = nmfill '-' "" : replicate cnum (tyfill '-' "")
        entry e = nmfill ' ' (name e) : [ tyfill ' ' (cval ty) | ty <- tyCols ]
          where cval ty | ty `elem` types e  = "exist"
                        | otherwise          = "-"

printRecvMatrix :: IO ()
printRecvMatrix = putStr . unlines . listRecvMatrix =<< getRecvEntries
