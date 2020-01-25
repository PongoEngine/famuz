<img src="./famous.png" height="200"  align="right">

# Famuz

> A Modular Music Format for famous compositions.

Famuz is a programming language that compiles to Midi. The goal of this project is to create music from atomic musical definitions.

## Basic Syntax

```
basicRhythm =
    x~~~ x--- x~~~ x~--

//this is a comment
simpleSteps =
    0 1 2 3

simpleMelody =
    simpleSteps + basicRhythm

simpleLoop =
   arp(chord(TRIAD, simpleMelody))

main(simpleLoop + C# + harmonic-minor)
```