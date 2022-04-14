struct DomainModel {
    var text = "Hello, World!"
        // Leave this here; this value is also tested in the tests,
        // and serves to make sure that everything is working correctly
        // in the testing harness and framework.
}

////////////////////////////////////
// Money
//
public struct Money {
    var amount : Int
    var currency : String
    
    init(amount amt: Int, currency curr: String) {
        self.amount = amt
        self.currency = curr
    }
    
    static func convertToUSD(_ amount: Double, _ currency: String) -> Double {
        var usdAmount : Double = amount
        
        switch currency {
            case "GBP":
                usdAmount *= 2.0
            case "EUR":
                usdAmount *= 2.0/3.0
            case "CAN":
                usdAmount *= 4.0/5.0
            default:
            usdAmount *= 1.0
        }
        
        // usdAmount.round()
        return usdAmount
    }
    
    func convert(_ currencyName: String ) -> Money {
        var convertedAmt = Money.convertToUSD(Double(self.amount), self.currency)
               
        switch currencyName {
            case "GBP":
                convertedAmt *= 0.5
            case "EUR":
                convertedAmt *= 1.5
            case "CAN":
                convertedAmt *= 1.25
            default:
                convertedAmt *= 1.0
        }
    
       // convertedAmt.round()
        return Money(amount: Int(convertedAmt), currency: currencyName)
    }
            
    
    func add (_ mon1 : Money ) -> Money {
        let currentMon1 = mon1.currency
        let currentMon2 = self.convert(currentMon1)
        return Money(amount: mon1.amount + currentMon2.amount, currency: currentMon1)
    }
    
    func subtract (_ mon1 : Money) -> Money {
        let currentMon1 = mon1.currency
        let currentMon2 = self.convert(currentMon1)
        return Money(amount: mon1.amount - currentMon2.amount, currency: currentMon1)
    }
}

////////////////////////////////////
// Job
//
public class Job {
    var title : String
    var type : JobType
    
    init(title: String, type: JobType) {
        self.title = title
        self.type = type
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(UInt)
    }
    
    func calculateIncome(_ hour: Int) -> Int {
        switch self.type {
            case .Hourly(let hourlyRate):
                return Int(hourlyRate * Double(hour))
            case .Salary(let salary):
                return Int(salary)
        }
    }
    
    func raise(byAmount: Double){
        switch self.type {
            case .Hourly(let hourlyRate):
                self.type = JobType.Hourly(hourlyRate + byAmount)
            case .Salary(let salary):
                self.type = JobType.Salary(UInt(Double(salary) + byAmount))
            }
    }
    
    func raise(byPercent: Double){
        switch self.type {
            case .Hourly(let hourlyRate):
                let raise = hourlyRate * byPercent
                self.type = JobType.Hourly(hourlyRate + raise)
            case .Salary(let salary):
                let raise = UInt(Double(salary) * byPercent)
                self.type = JobType.Salary(salary + raise)
            }
    }
}

////////////////////////////////////
// Person
//
public class Person {
    var firstName: String
    var lastName: String
    var age: Int
    var job: Job? {
        didSet {
            if age < 18 {
                job = nil
            }
        }
    }
    
    var spouse: Person? {
        didSet {
            if age < 21 {
                spouse = nil
            }
        }
    }
    
    init (firstName: String, lastName: String, age: Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    func toString() -> String {
        return String("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]")
    }
}

////////////////////////////////////
// Family
//
public class Family {
    var members: Array<Person>
    
    init(spouse1: Person, spouse2: Person) {
        self.members = []
        if (spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members = [spouse1, spouse2]
        }
    }
    
    func haveChild(_ child: Person) -> Bool {
        if (members.count == 2) {
            if (members[0].age > 21 || members[1].age > 21) {
                members.append(child)
                return true
            }
        }
        return false
    }
    
    func householdIncome() -> Int {
        var totalIncome = 0
        for member in members {
            if member.job != nil {
                totalIncome += member.job!.calculateIncome(2000)
            }
        }
        return totalIncome
    }
}
