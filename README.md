<img src="./famous.png" height="200"  align="right">

# Famuz
> A modular music format for famous compositions.


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
