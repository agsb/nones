# TOKEEBS

Using the NGSL 1.2 to define proprieties for a confortable and eficient keyboad.

## NGSL

## Process

The 2803 words of NGSL 1.2 are represented as "lemma fppm", where fppm 
is the frequencie of lemma per million.

Then for each letter the fppm of ocurrences in all lemmas are normalized
as absolute percentual, and same for digraphs, trigraphs and tetragraphs
using space at begin and ends of lemmas. The unused digraphs are listed.

## telephone numeric 12 keys

Old telephone keyboards have a letter layout over the numeric 12 keys.

For access the letter must press it 1 or 2 or 3 times. 
Like 8(t)44(h)-1-444(i)7777(s)

```
    1 record on/off
    2 abc
    3 def
    4 ghi
    5 jkl
    6 mno
    7 pqrs
    8 tuv
    9 wxyz
    0 space
    * 1a?
    # shift on/off
```

What could be a better layout ? Using the frequency of letters on NGLS
and minimize finger movement for most used words.

0   reserved 
\*  for 12 selects as letters, symbols, functions, etc
\#  for 12 controls and alone to ends key repeats

1, 2, 3, 4, 5, 6, 7, 8, 9 for arranje multiples signs

One key for space, and backspace, and 8 keys for arranje 26 letters, 
then 6 keys with 3 letters and 2 keys with four. 

How define the groups of letters for each keys?

## Restrictions

Assign keys in order frequency list. Use NGSL.
No digraph in same key, possible 27 * 27 = 729, real   
No trigraph in same key, 
Balance counts to minimize overuse,

## Process

After processing, the order of letters in groups of 8, 

e t o a n h i r -- s l d u c b f y -- m w p g v k x j -- q z 


## References


https://newgeneralservicelist/s/NGSL_12_stats.csv

https://newgeneralservicelist/s/NAWL_10_stats.csv


