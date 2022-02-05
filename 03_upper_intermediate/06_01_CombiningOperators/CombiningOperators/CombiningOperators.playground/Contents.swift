import RxSwift
import Foundation

let disposeBag = DisposeBag()

print("------ startWith ------")
let classA = Observable.of("👧🏼", "🧒🏻", "👦🏽")

classA
    .startWith("👨🏻선생님")
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------ concat 1 ------")
let classAKids = Observable.of("👧🏼", "🧒🏻", "👦🏽")
let teacher = Observable.of("👨🏻")

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
let 어린이집 = [
    "노랑반": Observable.of("👧🏼", "🧒🏻", "👦🏽"),
    "파랑반": Observable.of("👶🏾", "👶🏻")
]

Observable.of("노랑반", "파랑반")
    .concatMap { 반 in
        어린이집[반] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)


print("------ merge 1 ------")
let northSide = Observable.from(["강북구", "성북구", "동대문구", "종로구"])
let southSide = Observable.from(["강남구", "강동구", "영등포구", "양천구"])

Observable.of(northSide, southSide)
    .merge()
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
    })
    .disposed(by: disposeBag)


print("------ merge 2 ------")
Observable.of(northSide, southSide)
    .merge(maxConcurrent: 1)
    .subscribe(onNext: {
        print("서울특별시의 구:", $0)
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

familyName.onNext("김")
givenName.onNext("똘똘")
givenName.onNext("영수")
givenName.onNext("은영")
familyName.onNext("박")
familyName.onNext("이")
familyName.onNext("조")


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
let player = Observable<String>.of("🇰🇷", "🇨🇭", "🇺🇸", "🇧🇷", "🇯🇵", "🇨🇳")

let matchResult = Observable.zip(match, player) { result, keyPlayer in
    return keyPlayer + "player" + " \(result)!"
}

matchResult
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

print("----------withLatestFrom1----------")
let 💥🔫 = PublishSubject<Void>()
let runner = PublishSubject<String>()

💥🔫.withLatestFrom(runner)
//    .distinctUntilChanged()     //Sample과 똑같이 쓰고 싶을 때
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

runner.onNext("🏃🏻‍♀️")
runner.onNext("🏃🏻‍♀️ 🏃🏽‍♂️")
runner.onNext("🏃🏻‍♀️ 🏃🏽‍♂️ 🏃🏿")
💥🔫.onNext(Void())
💥🔫.onNext(Void())


print("------ sample ------")
let start = PublishSubject<Void>()
let f1Player = PublishSubject<String>()

f1Player.sample(start)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

f1Player.onNext("🏎")
f1Player.onNext("🏎   🚗")
f1Player.onNext("🏎      🚗   🚙")
start.onNext(Void())
start.onNext(Void())
start.onNext(Void())


print("----------switchLatest----------")
let 👩🏻‍💻학생1 = PublishSubject<String>()
let 🧑🏽‍💻학생2 = PublishSubject<String>()
let 👨🏼‍💻학생3 = PublishSubject<String>()

let 손들기 = PublishSubject<Observable<String>>()

let 손든사람만말할수있는교실 = 손들기.switchLatest()
손든사람만말할수있는교실
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 저는 1번 학생입니다.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저요 저요!!!")

손들기.onNext(🧑🏽‍💻학생2)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 저는 2번이예요!")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아.. 나 아직 할말 있는데")

손들기.onNext(👨🏼‍💻학생3)
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 아니 잠깐만! 내가! ")
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 언제 말할 수 있죠")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 저는 3번 입니다~ 아무래도 제가 이긴 것 같네요.")

손들기.onNext(👩🏻‍💻학생1)
👩🏻‍💻학생1.onNext("👩🏻‍💻학생1: 아니, 틀렸어. 승자는 나야.")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: ㅠㅠ")
👨🏼‍💻학생3.onNext("👨🏼‍💻학생3: 이긴 줄 알았는데")
🧑🏽‍💻학생2.onNext("🧑🏽‍💻학생2: 이거 이기고 지는 손들기였나요?")


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
