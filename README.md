<img src="./famous.png" height="200"  align="right">

# Famuz

> A Modular Music Format for famous compositions.

Famuz is a programming language that compiles to Midi. The goal of this project is to create music from atomic musical definitions.

## Simple Example

``` javascript
enum Robot {
    SWAG
    TURKEY
}

section = SWAG

switchVal = switch section {
    case 1, 2: 10 + 200
    case 20: 20
    case SWAG: 99
    default: -20
}

dag = -30

func main() {
    print(switchVal)
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