import Foundation
 
func makeGugu(input: Int){
    _ = Array(1...9).map { print("\(input) x \($0) = \(input * $0)") }
}
 
func gugu() {
  print("구구단을 외자 : ", terminator: "")
 
 if let input = readLine() {
   switch input {
     case "-1", "0", "1" :
        print("입력이 잘못되었습니다.")
     case "exit" :
        return
     default :
        if let num = Int(input) { makeGugu(input: num) }
   }
 } 
  gugu()
}
 
gugu()