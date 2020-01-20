#pragma once

/*
 * Copyright (c) 2019 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <stdbool.h>
#include <ctype.h>
#include <string.h>
#include "../compiler/lexer/lexer-token.h"

bool is_whitespace(char ch)
{
    return (ch == L_SPACE) || (ch == L_TAB) || (ch == L_LINE);
}

bool is_identifer(char ch)
{
    return ch != L_ADD && ch != L_FORWARD_SLASH &&
           ch != L_TAB && ch != L_SPACE && ch != L_LINE &&
           ch != L_LEFT_PARAM && ch != L_RIGHT_PARAM && ch != L_COMMA;
}

bool is_rhythm(char ch)
{
    return ch == L_HIT || ch == L_DURATION || ch == L_REST || ch == L_SPACE;
}

bool is_steps(char ch)
{
    return isdigit(ch) || ch == L_SPACE;
}

bool is_empty(char *str)
{
    return str == NULL || strlen(str) == 0;
}

// //https://github.com/vegardit/haxe-strings/blob/master/src/hx/strings/Strings.hx

// class StringUtil
// {
//     /**
//      * [Description]
//      * @param left
//      * @param right
//      */
//     public static function getFuzzyDistance(left:String, right:String) : Int {
//         if (left.isEmpty() || right.isEmpty())
//             return 0;

//         left = left.toLowerCase();
//         right = right.toLowerCase();

//         var leftChars = left.toChars();
//         var rightChars = right.toChars();
//         var leftLastMatchAt = -100;
//         var rightLastMatchAt = -100;

//         var score = 0;

//         for (leftIdx in 0...leftChars.length) {
//             var leftChar = leftChars[leftIdx];
//             for (rightIdx in (rightLastMatchAt > -1 ? rightLastMatchAt + 1 : 0)...rightChars.length) {
//                 var rightChar = rightChars[rightIdx];
//                 if (leftChar == rightChar) {
//                     score++;
//                     if ((leftLastMatchAt == leftIdx - 1) && (rightLastMatchAt == rightIdx - 1)) {
//                         score += 2;
//                     }
//                     leftLastMatchAt = leftIdx;
//                     rightLastMatchAt = rightIdx;
//                     break;
//                 }
//             }
//         }

//         return score;
//     }