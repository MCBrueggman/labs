/* Mike Brueggman, Aug 31, 2026
   ============================================================
// MODULE 4: Swift Programming Fundamentals
// Exercises — Types, Variables, and Control Flow
// Enterprise Mobile Application Development Bootcamp
// ============================================================
//
// HOW TO USE THIS FILE
// Open this file in an Xcode Playground (File → New → Playground → iOS).
// Work through each exercise in order. Each TODO tells you exactly
// what to write. Run the playground after each exercise to verify.
//
// These exercises build on each other. Do not skip ahead.
//
// ------------------------------------------------------------
// BACKGROUND FOR THIS COHORT
// If you are coming from Python or JavaScript, Swift will feel
// familiar in some ways and strict in others. The strictness
// is intentional — it catches entire categories of bugs at
// compile time that Python and JS surface only at runtime.
// Keep that in mind when the compiler pushes back on you.
// ------------------------------------------------------------*/

import Foundation


// ============================================================
// EXERCISE 1: Constants and Variables
// Estimated time: 10 minutes
//
// In Python you write: x = 5
// In Swift you choose: let x = 5  (constant, cannot change)
//                       var x = 5  (variable, can change)
//
// The rule: reach for let first. Use var only when you know
// the value must change. The compiler will enforce this.
// ============================================================

// TODO 1a: Declare a constant named appName with the value "PNC Mobile".
// Use let. Try assigning a new value to it afterward — read the error,
// then remove the bad assignment.
var appName = "PNC Mobile"

// TODO 1b: Declare a variable named loginAttempts and set it to 0.
// Then increment it by 1 on the next line using +=
var loginAttempts = 0
loginAttempts+=1

// TODO 1c: Declare a constant named accountBalance of type Double
// with value 4_250.75
// (Note: Swift lets you use _ as a thousands separator for readability)
let accountBalance = 4_250.75

// TODO 1d: Swift uses TYPE INFERENCE — it figures out the type from
// the value. But sometimes you must be explicit.
// Declare a variable named interestRate with explicit type annotation
// Double, and assign it 0.035
let interestRate: Double = 0.035

// CHECK: Print all four values using print(). Run the playground.
// Expected output (roughly):
//   PNC Mobile
//   1
//   4250.75
//   0.035
print(appName)
print(loginAttempts)
print(accountBalance)
print(interestRate)
let divider = "---------------------------------"
print(divider)
// ============================================================
// EXERCISE 2: Working with Strings
// Estimated time: 10 minutes
//
// Swift strings are VALUE TYPES — unlike Python strings they are
// the same, but unlike JS objects they are NOT reference types.
// The big addition: string interpolation with \()
// ============================================================

// TODO 2a: Declare constants firstName = "Jane" and lastName = "Smith"
let firstName = "Jane"
let lastName = "Smith"

// TODO 2b: Using string interpolation, create a constant fullName
// that combines them with a space between.
// Format: "Jane Smith"
let fullName = "\(firstName) \(lastName)"

// TODO 2c: Create a constant greeting that produces:
// "Welcome to PNC Mobile, Jane Smith. Your account is active."
// Use interpolation — do not use string concatenation with +
let appGreeting = "Welcome to \(appName) \(fullName). Your account is active"

// TODO 2d: Declare a constant accountNumber = "1234567890"
// Use String methods to create a masked version showing only the last 4 digits.
// Hint: String(accountNumber.suffix(4)) gives you "7890"
// Your masked version should be "****7890"
// Store it in a constant named maskedAccount
let accountNumber = "1234567890"
let maskedAccount = "******\(String(accountNumber.suffix(4)))"


// TODO 2e: Using the string properties available on Swift strings,
// print the number of characters in fullName.
// Hint: .count
let nameStringCount = fullName.count

// CHECK: Print greeting and maskedAccount. Verify output matches expectations.
print(appGreeting)
print("Your account number is \(maskedAccount)")
print(divider)

// ============================================================
// EXERCISE 3: Type Safety and Conversion
// Estimated time: 10 minutes
//
// This is where Swift feels STRICT compared to Python/JS.
// Python: total = "Balance: " + 4250.75  → works (kind of)
// JS:     total = "Balance: " + 4250.75  → "Balance: 4250.75" (coercion)
// Swift:  Cannot add String and Double     → COMPILER ERROR
//
// You must convert explicitly. This prevents an entire class of bugs.
// ============================================================

// TODO 3a: You have these two values:
let transactionCount = 47          // Int
let transactionTotal = 12_309.88   // Double

// Try this line — it won't compile. Read the error.
// let average = transactionTotal / transactionCount

// TODO 3b: Fix it by converting transactionCount to Double inline.
// Store the result in a constant named averageTransaction.
let average = transactionTotal / Double(transactionCount)

// TODO 3c: Create a formatted string that reads:
// "47 transactions averaging $261.91 each"
// Use String(format: "%.2f", averageTransaction) to format the Double.
// Store it in a constant named summary and print it.
let summary = "\(transactionCount) transactions averaging $\(String(format: "%.2f", average)) each"
print(summary)

// TODO 3d: Swift optionals — preview
// This is a common pattern. String-to-Int conversion returns an
// OPTIONAL because the string might not be a valid number.
let rawInput = "2500"
let parsedAmount = Int(rawInput)   // This is Int?, not Int

// TODO: Use if let to safely unwrap parsedAmount and print:
// "Parsed amount: 2500"
// If it's nil, print: "Invalid input"
if let parsedAmount{
    print("Parsed amount: \(parsedAmount)")
}else{
    print("Invalid input")
}
print(divider)

// ============================================================
// EXERCISE 4: Control Flow
// Estimated time: 15 minutes
//
// Swift if/else looks like Python but requires braces {}.
// Swift switch is EXHAUSTIVE — every possible value must be handled.
// Switch cases do NOT fall through by default (unlike C/Java).
// This is one of the most important differences from other languages.
// ============================================================

// TODO 4a: Write an if/else if/else chain for this balance:
let balance: Double = 8_500.00

// Rules:
//   balance > 25_000  → print "Private Banking eligible"
//   balance > 10_000  → print "Preferred client"
//   balance > 1_000   → print "Standard account"
//   otherwise         → print "Low balance alert"
if balance > 25_000.00{
    print("Private Banking eligible")
}else if balance > 10_000.00 {
    print("Preferred client")
}else if balance > 1_000.00 {
    print("Standard account")
}else{
    print("Low balance alert")
}

// TODO 4b: Switch with pattern matching
// Swift switch can match ranges — far more powerful than Python/JS
let creditScore = 714

// Write a switch statement on creditScore:
//   800...850  → "Exceptional"
//   740...799  → "Very Good"
//   670...739  → "Good"          ← creditScore should land here
//   580...669  → "Fair"
//   default    → "Poor"
// Print "Credit rating: [result]"

switch creditScore{
    case 800...850:
        print("Exceptional")
    case 740...799:
        print("Very Good")
    case 670...739:
        print("Good")
    case 580...669:
        print("Fair")
    default:
        print("Poor")
}

// TODO 4c: Switch on an "enum"
// For now, use a String:
let transactionType = "transfer"

// Write a switch on transactionType with cases:
//   "deposit"    → "Processing deposit"
//   "withdrawal" → "Processing withdrawal"
//   "transfer"   → "Processing transfer"
//   default      → "Unknown transaction type: \(transactionType)"
// Print the result.
switch transactionType{
    case "deposit":
        print("Processing deposit")
    case "withdrawl":
        print("Processing withdrawl")
    case "transfer":
        print("Processing transfer")
    default:
        print("Unknown transaction type: \(transactionType)")
}

// TODO 4d: Guard statement
// guard is Swift's early-exit pattern. It is the idiomatic way to
// validate preconditions at the top of a function.
// Syntax:
//   guard condition else { return / throw / break }
//   // execution continues here only if condition was true

func processWithdrawal(amount: Double, availableBalance: Double) -> String {
    // TODO: Add a guard statement that returns "Invalid amount"
    // if amount is less than or equal to zero.
    guard amount <= 0 else{
        return("Invalid amount")
    }
    // TODO: Add a second guard that returns
    // "Insufficient funds. Available: $X.XX"
    // if amount exceeds availableBalance.
    // Use String(format: "%.2f", availableBalance) for the dollar format.
    guard amount >= availableBalance else{
        return("Insufficeint funds. Avalible: $\(String(format: "%.2f", availableBalance))")
    }
    return "Withdrawal of $\(String(format: "%.2f", amount)) approved"
}

// Test your function:
print(processWithdrawal(amount: -50, availableBalance: 1000))       // Invalid amount
print(processWithdrawal(amount: 2000, availableBalance: 1000))      // Insufficient funds
print(processWithdrawal(amount: 500, availableBalance: 1000))       // Approved

print(divider)
// ============================================================
// EXERCISE 5: Loops and Collections (Introduction)
// Estimated time: 15 minutes
//
// Swift has for-in (like Python's for x in y),
// while, and repeat-while (like do-while in Java).
// ============================================================

// TODO 5a: for-in over a range
// Print the multiplication table for 7: "7 x 1 = 7" through "7 x 10 = 70"
// Use a closed range: 1...10
print("Multiplication table for 7: ")
for num in 1...10{
    print("7 x \(num) = ", 7 * num)
}

// TODO 5b: for-in with where clause (built-in filter)
// Print only the even numbers from 1 through 20.
// Use: for num in 1...20 where num % 2 == 0
print("Even nums 1-20")
for num in 1...20 where num % 2 == 0{
    print(num)
}

// TODO 5c: Array basics
// Declare an array of account names:
// ["Checking", "Savings", "Investment", "Credit Card"]
// Use for-in to print each one prefixed with a bullet:
// "• Checking"
// "• Savings"
// etc.
let accountArray = ["Checking", "Savings", "Investment", "Credit Card"]
for i in 0...3{
    print("• \(accountArray[i])")
}
// TODO 5d: Array with enumerated()
// Using the same array, print each item with its position number:
// "1. Checking"
// "2. Savings"
// etc.
// Hint: for (index, name) in accounts.enumerated()
// Note: enumerated() starts at 0 — add 1 to the index when printing.
for (index, accountArray) in accountArray.enumerated(){
    print("\(index). \(accountArray)")
} 

// TODO 5e: while loop
// Simulate a connection retry loop.
// Start with var attempts = 0 and var connected = false
// Loop while !connected and attempts < 3:
//   - increment attempts
//   - print "Connection attempt \(attempts)..."
//   - if attempts == 3, set connected = true and print "Connected."
var attempts = 0;
var connected = false;
while (!connected && attempts < 3){
    attempts += 1
    print("Connection attempts \(attempts)")
    if(attempts==3){
        connected = true
        print("Connected")
    }
}

// ============================================================
// REVIEW QUESTIONS
// ============================================================
//
// BEFORE YOU LEAVE TODAY:
// 1. Can you explain WHY Swift requires explicit type conversion?
// A: Swift requires explicit type conversion because all types are fixed; you can't switch from ints to floats without casting one to the other
// 2. What is the difference between let and var?
// A: A let is Swift's version of a constant/fixed value item, whereas var is their version of a mutable variable
// 3. When would you use guard instead of if?
// A: You would use guard instead of if when you run into nesting situations that create the "Pyramid of Doom" (too many Ifs stacked on each other)
// 4. What makes Swift's switch statement different from Python's
//    match statement or JavaScript's switch?
// A: Swift's switch statement allows for both falling through and being able to autoskip the rest of the cases without breaks
// ============================================================
/*Console Output:
> xcrun swift -swift-version 6 /Volumes/Macintosh_HD/Users/user301537/Downloads/VariableTypes.swift

/Volumes/Macintosh_HD/Users/user301537/Downloads/VariableTypes.swift:179:11: warning: will never be executed
176 | //   balance > 1_000   → print "Standard account"
177 | //   otherwise         → print "Low balance alert"
178 | if balance > 25_000.00{
    |            `- note: condition always evaluates to false
179 |     print("Private Banking eligible")
    |           `- warning: will never be executed
180 | }else if balance > 10_000.00 {
181 |     print("Preferred client")

/Volumes/Macintosh_HD/Users/user301537/Downloads/VariableTypes.swift:181:11: warning: will never be executed
178 | if balance > 25_000.00{
179 |     print("Private Banking eligible")
180 | }else if balance > 10_000.00 {
    |                  `- note: condition always evaluates to false
181 |     print("Preferred client")
    |           `- warning: will never be executed
182 | }else if balance > 1_000.00 {
183 |     print("Standard account")

PNC Mobile
1
4250.75
0.035
---------------------------------
Welcome to PNC Mobile Jane Smith. Your account is active
Your account number is ******7890
---------------------------------
47 transactions averaging $261.91 each
Parsed amount: 2500
---------------------------------
Standard account
Good
Processing transfer
Insufficeint funds. Avalible: $1000.00
Invalid amount
Invalid amount
---------------------------------
Multiplication table for 7: 
7 x 1 =  7
7 x 2 =  14
7 x 3 =  21
7 x 4 =  28
7 x 5 =  35
7 x 6 =  42
7 x 7 =  49
7 x 8 =  56
7 x 9 =  63
7 x 10 =  70
Even nums 1-20
2
4
6
8
10
12
14
16
18
20
• Checking
• Savings
• Investment
• Credit Card
0. Checking
1. Savings
2. Investment
3. Credit Card
Connection attempts 1
Connection attempts 2
Connection attempts 3
Connected
/Volumes/Macintosh_HD/Users/user301537/Downloads/VariableTypes.swift:185:11: warning: will never be executed
180 | }else if balance > 10_000.00 {
181 |     print("Preferred client")
182 | }else if balance > 1_000.00 {
    |                  `- note: condition always evaluates to true
183 |     print("Standard account")
184 | }else{
185 |     print("Low balance alert")
    |           `- warning: will never be executed
186 | }
187 | 
 *  Terminal will be reused by tasks, press any key to close it. 
*/