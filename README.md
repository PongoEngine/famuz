<img src="./famous.png" height="200"  align="right">

# Famuz

> A Modular Music Format for famous compositions.

Famuz is a programming language that compiles to Midi. The goal of this project is to create music from atomic musical definitions.

## Simple Example

``` javascript
func robot(val)
{
    grand = 42
    val + 290
}

func great(hello :Number)
{
    robot(hello) + 190
}

func cool() :Number
{
    great(400)
}

steps = \1 2 3 4
rhythm = \x--- x--- x--- x---

key :Key = C
scale :Scale = major

r = 5 + print(cool())

func main() {
    melody = print(steps + rhythm)
    scaledKey = print(scale + key)
    melody + scaledKey
}
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