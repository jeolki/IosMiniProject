import RxSwift
import Foundation

let disposeBag = DisposeBag()

print("------ startWith ------")
let classA = Observable.of("π§πΌ", "π§π»", "π¦π½")

classA
    .startWith("π¨π»μ μλ")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------ concat 1 ------")
let classAKids = Observable.of("π§πΌ", "π§π»", "π¦π½")
let teacher = Observable.of("π¨π»")

let walkingInLine = Observable
    .concat([teacher, classAKids])
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------ concat 2 ------")
teacher
    .concat(classAKids)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("------ concatMap ------")
let μ΄λ¦°μ΄μ§ = [
    "λΈλλ°": Observable.of("π§πΌ", "π§π»", "π¦π½"),
    "νλλ°": Observable.of("πΆπΎ", "πΆπ»")
]

Observable.of("λΈλλ°", "νλλ°")
    .concatMap { λ° in
        μ΄λ¦°μ΄μ§[λ°] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------ merge 1 ------")
let northSide = Observable.from(["κ°λΆκ΅¬", "μ±λΆκ΅¬", "λλλ¬Έκ΅¬", "μ’λ‘κ΅¬"])
let southSide = Observable.from(["κ°λ¨κ΅¬", "κ°λκ΅¬", "μλ±ν¬κ΅¬", "μμ²κ΅¬"])

Observable.of(northSide, southSide)
    .merge()
    .subscribe(onNext: {
        print("μμΈνΉλ³μμ κ΅¬:", $0)
    })
    .disposed(by: disposeBag)


print("------ merge 2 ------")
Observable.of(northSide, southSide)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print("μμΈνΉλ³μμ κ΅¬:", $0)
    })
    .disposed(by: disposeBag)


print("------ combineLatest 1 ------")
let familyName = PublishSubject<String>()
let givenName = PublishSubject<String>()

let name = Observable.combineLatest(familyName, givenName) { familyName, givenName in
    familyName + givenName
}

name
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

familyName.onNext("κΉ")
givenName.onNext("λλ")
givenName.onNext("μμ")
givenName.onNext("μμ")
familyName.onNext("λ°")
familyName.onNext("μ΄")
familyName.onNext("μ‘°")


print("------ combineLatest 2 ------")
let dateDisplayFormat = Observable<DateFormatter.Style>.of(.short, .long)
let currentDate = Observable<Date>.of(Date())

let currentDateDisplay = Observable
    .combineLatest(
        dateDisplayFormat,
        currentDate,
        resultSelector: { dateFormat, dateNumber -> String in
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = dateFormat
            return dateFormatter.string(from: dateNumber)
        }
    )

currentDateDisplay
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------ combineLatest 3 ------")
let lastName = PublishSubject<String>()
let firstName = PublishSubject<String>()

let fullName = Observable.combineLatest([firstName, lastName]) { name in
    name.joined(separator: " ")
}

fullName
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

lastName.onNext("Kim")
firstName.onNext("Paul")
firstName.onNext("Stella")
firstName.onNext("Lily")


print("------ zip ------")
enum winLose {
    case win
    case lose
}

let match = Observable<winLose>.of(.win, .win, .lose, .win, .lose)
let player = Observable<String>.of("π°π·", "π¨π­", "πΊπΈ", "π§π·", "π―π΅", "π¨π³")

let matchResult = Observable.zip(match, player) { result, keyPlayer in
    return keyPlayer + "player" + " \(result)!"
}

matchResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------withLatestFrom1----------")
let π₯π« = PublishSubject<Void>()
let runner = PublishSubject<String>()

π₯π«.withLatestFrom(runner)
//    .distinctUntilChanged()     //Sampleκ³Ό λκ°μ΄ μ°κ³  μΆμ λ
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("ππ»ββοΈ")
runner.onNext("ππ»ββοΈ ππ½ββοΈ")
runner.onNext("ππ»ββοΈ ππ½ββοΈ ππΏ")
π₯π«.onNext(Void())
π₯π«.onNext(Void())


print("------ sample ------")
let start = PublishSubject<Void>()
let f1Player = PublishSubject<String>()

f1Player.sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

f1Player.onNext("π")
f1Player.onNext("π   π")
f1Player.onNext("π      π   π")
start.onNext(Void())
start.onNext(Void())
start.onNext(Void())


print("----------switchLatest----------")
let π©π»βπ»νμ1 = PublishSubject<String>()
let π§π½βπ»νμ2 = PublishSubject<String>()
let π¨πΌβπ»νμ3 = PublishSubject<String>()

let μλ€κΈ° = PublishSubject<Observable<String>>()

let μλ μ¬λλ§λ§ν μμλκ΅μ€ = μλ€κΈ°.switchLatest()
μλ μ¬λλ§λ§ν μμλκ΅μ€
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

μλ€κΈ°.onNext(π©π»βπ»νμ1)
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μ λ 1λ² νμμλλ€.")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ μ μ μ!!!")

μλ€κΈ°.onNext(π§π½βπ»νμ2)
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ λ 2λ²μ΄μμ!")
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μ.. λ μμ§ ν λ§ μλλ°")

μλ€κΈ°.onNext(π¨πΌβπ»νμ3)
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μλ μ κΉλ§! λ΄κ°! ")
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μΈμ  λ§ν  μ μμ£ ")
π¨πΌβπ»νμ3.onNext("π¨πΌβπ»νμ3: μ λ 3λ² μλλ€~ μλ¬΄λλ μ κ° μ΄κΈ΄ κ² κ°λ€μ.")

μλ€κΈ°.onNext(π©π»βπ»νμ1)
π©π»βπ»νμ1.onNext("π©π»βπ»νμ1: μλ, νλ Έμ΄. μΉμλ λμΌ.")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: γ γ ")
π¨πΌβπ»νμ3.onNext("π¨πΌβπ»νμ3: μ΄κΈ΄ μ€ μμλλ°")
π§π½βπ»νμ2.onNext("π§π½βπ»νμ2: μ΄κ±° μ΄κΈ°κ³  μ§λ μλ€κΈ°μλμ?")


print("----------reduce----------")
Observable.from((1...10))
    .reduce(0, accumulator: { summary, newValue in
        return summary + newValue
    })
//    .reduce(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------scan----------")
Observable.from((1...10))
    .scan(0, accumulator: +)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)
