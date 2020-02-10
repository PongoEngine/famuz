<img src="./famous.png" height="200"  align="right">

# Famuz

> A Modular Music Format for famous compositions.

Famuz is a programming language that compiles to Midi. The goal of this project is to create music from atomic musical definitions.

## Simple Example

``` javascript
basicRhythm : Rhythm = x~~~ x--- x~~~ x~--
print(basicRhythm)

basicSteps = ^1 3 8 2 >> 1

anything = print(basicRhythm + basicSteps)
print(anything)
print((basicRhythm >> 3))

//func neptune(a :Steps, b :Steps, c :Steps) :Rhythm {
//    x~~~ x--- x~~~ x~--
//}

a = 1
b = 4
c = 3
d = a + b + c

result = print(d + 10000)
print(result)
```

## Famuz Types

    - rhythm -> "x~~~ x--- x~~~ x~--"
    - melody -> "rhythm + steps"
    - harmony -> fn(melody)
    - steps -> "0 1 2 3"
    - scale -> "harmonic-minor"
    - key -> "c#"
    - scaled-key -> scale + key
    - music -> scaled-key + (melody | harmony)