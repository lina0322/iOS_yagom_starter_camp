import Foundation

// step 1. 
/*
for i in 1...9 {
	for j in 1...9 {
		print("\(i) X \(j) = \(i * j)");
	}
}
*/

// step 2.
print("enter the number : ",  terminator: "")

while true {
	let input = readLine()!
	let end = String(input)

	if let num = Int(end) {
		if num >= 2 && num <= 9 { 
			for i in 1...9 {
				print("\(num) X \(i) = \(num * i) ")
			}
			print("enter the number : ",  terminator: "")
		} else {
			print("The number is wrong. Please re-enter. (2 <= n <= 9) : ", terminator: "")
		}     
	} else if end == "exit" {
		print("Exit the program.")
		break
	} else {
		print("Please enter only numbers. : ", terminator: "")
	}
}
