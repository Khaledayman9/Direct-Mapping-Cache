-- START OF THE PROJECT !



data Item a = It Tag (Data a) Bool Int | NotPresent deriving (Show, Eq)
data Tag = T Int deriving (Show, Eq)
data Data a = D a deriving (Show, Eq)

convertBinToDec :: Integral a => a -> a

convertBinToDec b = convertBinToDecHelper b 0

convertBinToDecHelper 0 _ = 0
convertBinToDecHelper b p= 2^p*(mod b 10) + convertBinToDecHelper (div b 10) (p+1)


replaceIthItem :: t -> [t] -> Int -> [t]

replaceIthItem _ [] _ = []
replaceIthItem item (x:xs) index | index == 0 = item:xs
                                  | otherwise = x : (replaceIthItem item xs (index-1) )


splitEvery :: Int -> [a] -> [[a]]

splitEvery 0 _ = error "N can not be 0"
splitEvery n l = splitEveryHelper n l [] 0

splitEveryHelper _ [] tmp _ = [tmp]

splitEveryHelper n (x:xs) tmp c | (n == c) = tmp: (splitEveryHelper n (x:xs) [] 0)
                                | otherwise = splitEveryHelper n xs (tmp++[x]) (c+1)

logBase2 :: Floating a => a -> a
logBase2 b = logBase 2 b


getNumBits  :: (Integral a, RealFloat a1) => a1 -> [Char] -> [c] -> a

getNumBits _  "fullyAssoc" _ = 0

getNumBits numOfSets "setAssoc" cache =  l where l = ceiling (logBase2 numOfSets)

getNumBits _ "directMap" cache = l where l = ceiling (logBase2 (fromIntegral (length cache)))

fillZeros :: [Char] -> Int -> [Char]

fillZeros number 0 = number 
fillZeros list n = fillZeros (['0']++list) (n-1)

convertAddress:: (Integral b1, Integral b2) => b1 -> b2 -> [Char] -> (b1, b1)
convertAddress binAddress bitsNum "directMap"  = (div binAddress (10^bitsNum),mod binAddress (10^bitsNum))

data Output a = Out (a, Int) | NoOutput deriving (Show, Eq)
getDataFromCache:: (Integral b, Eq a) =>[Char] -> [Item a] -> [Char] -> b -> Output a
getDataFromCache stringAddress cache "directMap" bitsNum = getDataFromCacheHelper (fst (convertAddress (read stringAddress :: Int) bitsNum "directMap"))  (cache!!(convertBinToDec (snd (convertAddress (read stringAddress :: Int) bitsNum "directMap"))))
getDataFromCacheHelper tag (It (T tag2) (D dr) y _) = if y == True && tag2 == tag then Out (dr,0) else NoOutput


concat :: Int -> Int -> Int
concat x y = read ((show x) ++ (show y))