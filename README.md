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

## Notes (for personal use)

- famuz
  - compiler
    - expr
      - expr-binop.h
      - expr-call.h
      - expr-constant.h
      - expr-var.h
      - expr.h
    - generator
      - generate.h
    - lexer
      - lexer-token.h
      - lexer.h
      - reserved.h
    - parser
      - parser-assignment.h
      - parser-binop.h
      - parser-identifier.h
      - parser-key.h
      - parser-left-param.h
      - parser-rhythm.h
      - parser-scale.h
      - parser-steps.h
      - parser.h
    - position.h
    - scanner.h
    - settings.h
    - token.h
    - type.h
  - util
    - assert.h
    - expr-printer.h
    - file-util.h
    - string-util.h
  - famuz.h