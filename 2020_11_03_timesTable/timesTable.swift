import Foundation

/*
for i in 1...9 {
	for j in 1...9 {
		print("\(i) X \(j) = \(i * j)");
	}
}
*/

print("enter the number : ",  terminator: "")

while true {
	guard let input = readLine() else {
		print("\nPlease enter only numbers. : ", terminator: "") 
		continue
	}

	if let num = Int(input) {
		if num >= 2 && num <= 9 { 
			for i in 1...9 {
				print("\(num) X \(i) = \(num * i) ")
			}
			print("enter the number : ",  terminator: "")
		} else {
			print("The number is wrong. Please re-enter. (2 <= n <= 9) : ", terminator: "")
		}     
	} else if input == "exit" {
		print("Exit the program.")
		break
	} else {
		print("Please enter only numbers. : ", terminator: "")
	}
}
