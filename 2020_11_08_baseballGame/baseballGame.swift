//  
// main.swift
// BullsAndCows
//
// Created by Lina Lim on 03/11/2020.
// Copyright © 2020 llim. All rights reserved.
//

// input 고치기, bulls and cows 함수 쪼개기
import Foundation

func makeNumber() -> [Int] {
  var numbers: [Int] = []
  while numbers.count < 3 {
    let random = Int.random(in: 1...9)
    if !numbers.contains(random) {
      numbers.append(random)
    }
  }
  return numbers
}

func printMenu() {
  print("1. 게임시작\n2. 게임종료\n원하는 기능을 선택해주세요 : ", terminator: "")
} 


func printInfo() {
  print("숫자 3개를 띄어쓰기로 구분하여 입력해주세요.")
  print("중복 숫자는 허용하지 않습니다.")
  print("입력 : ", terminator: "")
}

func printInputError() {
  print("입력이 잘못되었습니다.")
}

func printSystempError() {
  print("시스템 오류입니다.")
}

func getInputNumber() -> [Int] {
  var inputNumbers: [Int] = []

  while true {
    printInfo()

    guard let input = readLine() else { 
      printSystempError()
      continue 
    }

    let splitInput = input.split(separator: " ")
    if let numbers: [Int] = splitInput.map({ Int(String($0))! }) {
      if numbers.count == 3 {
        if numbers[0] != numbers[1] 
        && numbers[1] != numbers[2] 
        && numbers[0] != numbers[2] { inputNumbers = numbers }
      }
    }
  }
  return inputNumbers
}

func checkStrike(answer: [Int], input: [Int]) -> Int {
  var count: Int = 0
  for i in 0...2 {
    if answer[i] == input[i] { count = count + 1 }
  }
  return count
}

func checkBall(answer: [Int], input: [Int]) -> Int {
  var count: Int = 0
  for answerNumber in answer {
    for inputNumber in input {
      if answerNumber == inputNumber { count = count + 1 }
    }
  }
  return count
}

func startGame() -> ture {
  while true {
    printMenu()
    if let input = readLine() {
      switch input {
      case "1":
        break
      case "2":
        print("게임이 종료되었습니다.")
        return false
      default:
        printInputError()
        continue
      }
    }
    else {
      printSystempError()
      continue 
   }
  }
  return true
}

func BullsAndCows() {
  let answerNumber: [Int] = makeNumber()
  var inputNumber: [Int]
  var strike: Int
  var ball: Int
  var round: Int = 9

  if !startGame { return } 

  for _ in 1...9 {
    inputNumber = getInputNumber()
    strike = checkStrike(answer: answerNumber, input: inputNumber)
    ball = checkBall(answer: answerNumber, input: inputNumber) - strike
    print("\(strike) 스트라이크, \(ball) 볼")
    if strike == 3 { break }
    round = round - 1
    print("남은 기회 : \(round)")
  }
  if round > 1 { print("사용자 승리!") }
  else { print("컴퓨터 승리...!") }
  BullsAndCows()
}

BullsAndCows()