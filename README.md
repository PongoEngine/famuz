# Famuz

Famuz is a modular music format to create 'DRY' compositions using a bottom up approach.

Rhythms and Melodies are defined seperately and composed together using the pipe operator. Items can also be piped with functions such as 'Arp', 'Triad', or ...;

TODO: define syntax and write up a better readme.

Famuz does not support conditional statements. Other than noise and random, everything is cleary defined. All functions are deterministic with a globally defined seed.


## Basic Syntax

```
rhythm simpleRhythm
    4~~~ 4--- 9~~~ 3~--;

rhythm simpleRhythm2
    0~~~ 0--- 0~~~ 1~--;

steps simpleSteps
    0 1 2 3;

melody simpleMelody
    simpleSteps | simpleRhythm2; 

melody simpleLoop
    simpleMelody | triad | arp; 

melody simpleLoopRef
    simpleLoop; 

song coolExampleSong simpleLoopRef|C#|melodic-minor;
```
