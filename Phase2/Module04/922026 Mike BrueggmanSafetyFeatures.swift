// ============================================================
// MODULE 4: Swift Programming Fundamentals
// Day 3 Exercises — Protocols, ARC, Optionals, Error Handling
// Enterprise Mobile Application Development Bootcamp
// ============================================================
//
// Day 3 covers Swift's safety features — the ones that make
// iOS code reliable at enterprise scale. These concepts also
// directly underpin everything you will build in Modules 7–9.
//
// Part A: Protocols and Protocol-Oriented Programming
// Part B: Automatic Reference Counting (ARC) and memory safety
// Part C: Optionals — deep dive beyond the Day 1 preview
// Part D: Typed error handling
// Part E: Generics introduction
// ============================================================

import Foundation


// ============================================================
// PART A: PROTOCOLS
// ============================================================

// ============================================================
// EXERCISE 1: Defining and Adopting Protocols
// Estimated time: 20 minutes
//
// A protocol is a contract. Any type that says it conforms to
// a protocol MUST implement everything the protocol requires.
// This is Swift's primary mechanism for polymorphism —
// preferred over inheritance for most use cases.
//
// Python equivalent: Abstract Base Classes (abc.ABC)
// JS equivalent: TypeScript interfaces (but enforced at compile time)
// ============================================================

// TODO 1a: Define a protocol named Displayable with:

protocol Displayable{
    var displayDescription: String{ get }
    func printDetails()
}

// TODO 1b: Add a default implementation of printDetails() via a

extension Displayable{
    func printDetails(){
        print(displayDescription)
    }
}

// TODO 1c: Make Transaction (from ObjectOriented.swift) conform to Displayable.

struct Transaction: Displayable{
    let date: String
    let description: String
    let amount: Double

    var displayDescription: String {
        let formattedAmount = amount >= 0
            ? String(format: "$%.2f", amount)
            : String(format: "-$%.2f", abs(amount))

        return "\(date) \(description): \(formattedAmount)"
    }
}

//test transaction

let transaction1 = Transaction (
    date: "Jan 15, 2024",
    description: "Direct Deposit",
    amount: 2_500.00
)
transaction1.printDetails()


// TODO 1d: Protocol as a type

func printAll(items: [Displayable]){
    for item in items{
        item.printDetails()
    }
}
//Array of DisplayableItems
let transactions: [Displayable] = [
    Transaction(
        date: "Mar 2, 2024",
        description: "Direct Deposit",
        amount: 2_500.00
    ),
    Transaction(
        date: "April 15, 2024",
        description: "Tax Fraud",
        amount: 95_964.32
    )
]

printAll(items: transactions)
let divider = "-------------------------------------"
print(divider)
// ============================================================
// EXERCISE 2: Protocol-Oriented Design with Dependency Injection
// Estimated time: 20 minutes
//
// This pattern will appear in EVERY module from here forward.
// A protocol defines what a dependency does.
// Concrete types implement how it does it.
// The caller only knows about the protocol — never the concrete type.
// This is how we make code testable without a network.
// ============================================================

// TODO 2a: Define a protocol named AccountDataSource with:
protocol AccountDataSource{
    func fetchBalance(for accountId: String)->Double
    func fetchTransactionCount(for accountId: String)->Int
}

// TODO 2b: Create a struct MockAccountDataSource that conforms to
// AccountDataSource and returns hardcoded values:
struct MockAccountDataSource: AccountDataSource{
    func fetchBalance(for accountId: String)-> Double{
        return 4_250.75
    }
    func fetchTransactionCount(for accountId: String)->Int{
        return 47
    }
}

// TODO 2c: Create a struct LiveAccountDataSource that conforms to
// AccountDataSource and simulates real behavior:
struct LiveAccountDataSource: AccountDataSource{ 
    func fetchBalance(for accountId: String)->Double{
        return Double.random(in: 100...50_000)
    }
    func fetchTransactionCount(for accountId: String)->Int{
        return Int.random(in: 1...500)
    }
}

// TODO 2d: Write a class AccountDashboard that:
class AccountDashboard{
    let dataSource: AccountDataSource
    init(dataSource: AccountDataSource){
        self.dataSource = dataSource
    }
    func showSummary(for accountId: String){
        let balance = dataSource.fetchBalance(for: accountId)
        let transactionCount = dataSource.fetchTransactionCount(for: accountId)
        print(String(format: "Account %@: Balance %.2f | Transactions: %d", accountId, balance, transactionCount))
    }
}
let mockDashboard = AccountDashboard(dataSource: MockAccountDataSource())
let liveDashboard = AccountDashboard(dataSource: LiveAccountDataSource())
mockDashboard.showSummary(for: "ACC-001")
liveDashboard.showSummary(for: "ACC-001")
print(divider)
// ============================================================
// PART B: AUTOMATIC REFERENCE COUNTING
// ============================================================

// ============================================================
// EXERCISE 3: Retain Cycles and weak References
// Estimated time: 20 minutes
//
// ARC tracks how many things are pointing to each object.
// When the count reaches 0, Swift deallocates the memory.
// A retain cycle occurs when two objects hold STRONG references
// to each other — neither ever reaches 0, so neither is freed.
// This is a memory leak.
// ============================================================

// TODO 3a: Create a retain cycle, then fix it.
class Customer {
    let name: String 
    var account: Account?
    init(name: String){
        self.name = name 
    }
    deinit{
        print("Customer \(name) deallocated")
    }
}
class Account{
    let number: String
    weak var owner: Customer?
    init(number: String){
        self.number = number
    }
    deinit{
        print("Account \(number) deallocated")
    }
}
do{
    let customer = Customer(name: "Jane")
    let account = Account(number: "ACC_001")

    customer.account = account
    account.owner = customer
}

// TODO 3b: Capture lists in closures


class TransactionProcessor {
    let accountId: String
    var onComplete: (() -> Void)?

    init(accountId: String) {
        self.accountId = accountId
    }

    deinit {
        print("TransactionProcessor \(accountId) deallocated")
    }

    func startProcessing() {
        onComplete = {
            [weak self] in guard let self = self else {return}
            print("Processing complete for \(self.accountId)")
        }
    }

    func complete() {
        onComplete?()
    }
}


do{
    let processor = TransactionProcessor(accountId: "ACC-001")
    processor.startProcessing()
    processor.complete()
}

print(divider)

// ============================================================
// PART C: OPTIONALS — DEEP DIVE
// ============================================================

// ============================================================
// EXERCISE 4: Safe Unwrapping Patterns
// Estimated time: 20 minutes
//
// Day 1 introduced optionals briefly. Now we go deep.
// Optional<T> is an enum: either .some(value) or .none
// Every unwrapping pattern is just sugar over this enum.
// ============================================================

// TODO 4a: Optional chaining

struct Address {
    let street: String
    let city: String
    let zip: String?    // zip can be absent
}

struct UserProfile {
    let name: String
    var address: Address?   // address can be absent
}

let user = UserProfile(name: "Jane Smith", address: Address(
    street: "123 Main St", city: "Columbus", zip: "43001"))
let userNoAddress = UserProfile(name: "Bob", address: nil)

let zip = user.address?.zip ?? "No ZIP available"
print("ZIP: \(zip)")

let noAddressZip = userNoAddress.address?.zip ?? "No ZIP available"
print("ZIP: \(noAddressZip)")

// TODO 4b: if let with multiple bindings

func transfer(from sourceId: String?, to destId: String?, amount: Double?) {
    guard let sourceId = sourceId, let destId = destId, let amount = amount, amount > 0 else {
        print("Transfer failed: missing required fields")
        return
        
    }
    print(String(
            format: "Transfer $%.2f from %@ to %@ to be approved", amount, sourceId, destId
        ))
}

transfer(from: "ACC-001", to: "ACC-002", amount: 500.0)     // approved
transfer(from: nil, to: "ACC-002", amount: 500.0)           // failed
transfer(from: "ACC-001", to: "ACC-002", amount: nil)       // failed


// TODO 4c: Optional map and flatMap

let rawBalanceString: String? = "4250.75"
let rawInvalidString: String? = "abc"
let nilString: String? = nil

let formattedBalance = rawBalanceString
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0)} 
let formattedInvalid = rawInvalidString
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0)} 
let formattedNil = nilString 
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0)} 

print("rawBalanceString -> \(String(describing: formattedBalance))")
print("rawInvalidString -> \(String(describing: formattedInvalid))")
print("nilString -> \(String(describing: formattedNil))")
// TODO 4d: Force unwrap — when and ONLY when it's safe

let apiURL = URL(string: "https://api.pnc.com/v1")!
let userInputString = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
if let userURL = URL(string: userInputString){
    print("Valid URL: \(userURL)")
} else{
    print("Invalid URL")
}
print(divider)

// ============================================================
// PART D: TYPED ERROR HANDLING
// ============================================================

// ============================================================
// EXERCISE 5: Throwing Functions and Error Types
// Estimated time: 20 minutes
//
// Swift does NOT use exceptions like Python/Java.
// Instead: functions that can fail are marked throws.
// Callers MUST handle errors with do-catch or propagate with try?.
// The error types are DEFINED BY YOU — not the framework.
// This forces you to think about every failure mode up front.
// ============================================================

// TODO 5a: Define a comprehensive error enum for a transfer operation.
// Name it TransferError and conform to LocalizedError.
// Cases (with associated values where noted):
enum TransferError: LocalizedError {
    case invalidAmount
    case insufficientFunds(available: Double)
    case accountNotFound(id: String)
    case dailyLimitExceeded(limit: Double, attempted: Double)
    case networkUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidAmount:
            return "Transfer amount must be greater than zero."

        case .insufficientFunds(let available):
            return String(
                format: "Insufficient funds. Available balance: $%.2f.",
                available
            )

        case .accountNotFound(let id):
            return "Account not found: \(id)"

        case .dailyLimitExceeded(let limit, let attempted):
            return String(
                format: "Daily limit exceeded. Limit: $%.2f, attempted: $%.2f.",
                limit,
                attempted
            )

        case .networkUnavailable:
            return "Network is unavailable. Please try again later."
        }
    }
}

// TODO 5b: Write a throwing function:
// func executeTransfer(amount: Double, fromBalance: Double, toAccountId: String,
//                      dailyUsed: Double, dailyLimit: Double) throws -> String
//
// Throw the appropriate TransferError for each condition:
func executeTransfer(
    amount: Double,
    fromBalance: Double,
    toAccountId: String,
    dailyUsed: Double,
    dailyLimit: Double
) throws -> String {

    if amount <= 0 {
        throw TransferError.invalidAmount
    }

    if toAccountId.isEmpty {
        throw TransferError.accountNotFound(id: toAccountId)
    }

    if amount > fromBalance {
        throw TransferError.insufficientFunds(
            available: fromBalance
        )
    }

    if dailyUsed + amount > dailyLimit {
        throw TransferError.dailyLimitExceeded(
            limit: dailyLimit,
            attempted: dailyUsed + amount
        )
    }

    if toAccountId == "ERR_NET" {
        throw TransferError.networkUnavailable
    }

    return String(
        format: "Transfer of $%.2f to account %@ complete",
        amount,
        toAccountId
    )
}

// TODO 5c: Handle all error cases
func testTransfer(
    amount: Double,
    fromBalance: Double,
    toAccountId: String,
    dailyUsed: Double,
    dailyLimit: Double
) {
    do {
        let result = try executeTransfer(
            amount: amount,
            fromBalance: fromBalance,
            toAccountId: toAccountId,
            dailyUsed: dailyUsed,
            dailyLimit: dailyLimit
        )

        print(result)

    } catch let error as TransferError {
        print(error.errorDescription ?? "Unknown transfer error")
    } catch {
        print("Unexpected error: \(error)")
    }
}
// 1. Invalid amount
testTransfer(
    amount: -100,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 0,
    dailyLimit: 5000
)

// 2. Insufficient funds
testTransfer(
    amount: 6000,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 0,
    dailyLimit: 10000
)

// 3. Account not found
testTransfer(
    amount: 100,
    fromBalance: 5000,
    toAccountId: "",
    dailyUsed: 0,
    dailyLimit: 5000
)

// 4. Daily limit exceeded
testTransfer(
    amount: 2000,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 4000,
    dailyLimit: 5000
)

// 5. Network unavailable
testTransfer(
    amount: 100,
    fromBalance: 5000,
    toAccountId: "ERR_NET",
    dailyUsed: 0,
    dailyLimit: 5000
)

// 6. Success
testTransfer(
    amount: 250,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 0,
    dailyLimit: 5000
)


// TODO 5d: try? — silently converting failure to nil
let failedResult = try? executeTransfer(
    amount: -100,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 0,
    dailyLimit: 5000
)

print(failedResult ?? "Transfer failed")

let successfulResult = try? executeTransfer(
    amount: 250,
    fromBalance: 5000,
    toAccountId: "ACC-002",
    dailyUsed: 0,
    dailyLimit: 5000
)

print(successfulResult ?? "Transfer failed")

print(divider)
// ============================================================
// PART E: GENERICS — INTRODUCTION
// ============================================================

// ============================================================
// EXERCISE 6: Writing Generic Functions and Types
// Estimated time: 15 minutes
//
// Generics let you write one function or type that works with
// ANY type satisfying certain requirements. The alternative —
// writing separate versions for Int, Double, String, etc. —
// violates the DRY principle at the language level.
// ============================================================

// TODO 6a: Write a generic function named printFirst<T>
// that takes an array of any type T and prints the first element,
// or "Array is empty" if it has no elements.
// Test with: [Int], [String], [Double]
func printFirst<T>(_ array: [T]) {
    if let first = array.first {
        print(first)
    } else {
        print("Array is empty")
    }
}

printFirst([1, 2, 3])
printFirst(["Apple", "Banana", "Orange"])
printFirst([3.14, 2.71, 1.61])
printFirst([Int]())


// TODO 6b: Generic Stack
// Implement a generic value type Stack<Element>:
struct Stack<Element> {
    private var items: [Element] = []

    mutating func push(_ item: Element) {
        items.append(item)
    }

    mutating func pop() -> Element? {
        return items.popLast()
    }

    var top: Element? {
        return items.last
    }

    var isEmpty: Bool {
        return items.isEmpty
    }

    var count: Int {
        return items.count
    }
}

var transactionHistory = Stack<Double>()

transactionHistory.push(250.00)
transactionHistory.push(45.67)
transactionHistory.push(1200.00)

print(transactionHistory.pop()!)
print(transactionHistory.top!)
print(transactionHistory.count)


// TODO 6c: Generic function with constraint
// Write a function named findLargest<T: Comparable>
// that takes [T] and returns the largest element, or nil if empty.
// Test with: [Int], [Double], [String]
// Hint: collection.max()
func findLargest<T: Comparable>(_ array: [T]) -> T? {
    return array.max()
}

print(findLargest([10, 25, 7, 42, 18])!)
print(findLargest([3.14, 9.81, 2.71])!)
print(findLargest(["Apple", "Zebra", "Banana"])!)

let emptyResult = findLargest([Int]())
print(emptyResult ?? "No largest value")

print(divider)

// ============================================================
// END OF DAY 3 EXERCISES
// ============================================================
//
// YOU HAVE NOW COVERED ALL FIVE CONTENT BLOCKS OF MODULE 4.
// The capstone exercise ties everything together.
// Open Capstone/Capstone_Starter.swift to begin.
//
// FINAL REFLECTION:
// 1. What is a retain cycle? Draw it. How do you break one?
// 2. What is the difference between try, try?, and try!?
// 3. When would you use a protocol instead of a base class?
// 4. What constraint do you add to a generic type parameter
//    when you need to compare or sort elements?
// ============================================================
