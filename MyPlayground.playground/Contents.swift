//: Playground - noun: a place where people can play

import UIKit

let individualScores = [43, 39, 89, 92, 97, 44, 65, 32, 49, 74]
var teamScore = 0

for score in individualScores {
    if score > 50 {
        teamScore += 3
    } else {
        teamScore += 1
    }
}

print(teamScore)