# Famuz

Famuz is a modular music format to create 'DRY' compositions using a bottom up approach.

Rhythms and Melodies are defined seperately and composed together using the pipe operator. Items can also be piped with functions such as 'Arp', 'Triad', or ...;

TODO: define syntax and write up a better readme.

Famuz does not support conditional statements. Other than noise and random, everything is cleary defined. All functions are deterministic with a globally defined seed.

## Basic Syntax

```
simpleRhythm00000000 =
    x~~~ x--- x~~~ x~--

simplexxxxxxxxRhythm2 =
    x~~~ x--- x~~~ x~--

//this is a comment
simpleSteps =
    0 1 2 3

simpleMelody =
    simpleSteps + simpleRhythm00000000 //this is another comment

simpleLoop =
   arp(chord(TRIAD, simpleMelody))

main(x~~~ x--- x~~~ x~-- + 0 1 2 9 + C# + harmonic-minor)
```
