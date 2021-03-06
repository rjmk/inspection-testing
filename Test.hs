{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fplugin Test.Inspection.Plugin #-}
module Test (foo) where

import Test.Inspection

foo = 1
bar = 1
baz = 2

a f g = map f . map g
b f g = map (f . g)

-- Inspection test

inspect $ 'foo === 'bar
inspect $ 'bar === 'foo
inspect $ 'foo =/= 'baz
inspect $ 'bar =/= 'baz
inspect $ 'a === 'b


sumUp1 :: Int -> Bool
sumUp1 n = sum [1..n] > 1000

sumUp2 :: Int -> Bool
sumUp2 n | 1 > n = False
sumUp2 n = go 1 0 > 1000
    where
        go m s | m == n     = (s + m)
               | otherwise = go (m+1) (s+m)

dup :: a -> (a,a)
dup x = (x,x)

inspect $ 'sumUp1 === 'sumUp2

inspect $ 'sumUp1 `hasNoType` ''[]
inspect $ ('sumUp1 `hasNoType` ''Int) { expectFail = True }
inspect $ mkObligation 'sumUp1 NoAllocation
inspect $ (mkObligation 'dup NoAllocation) { expectFail = True }
