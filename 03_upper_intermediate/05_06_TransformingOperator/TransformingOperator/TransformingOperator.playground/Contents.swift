import RxSwift
import Foundation

let disposeBag = DisposeBag()

print("------ toArray ------")
Observable.of("A", "B", "C")
    .toArray()
    .subscribe(onSuccess: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ toArray ------
 ["A", "B", "C"]
*/

print("------ map ------")
Observable.of(Date())
    .map { date -> String in
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        return dateFormatter.string(from: date)
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ map ------
 2022-01-24
*/

print("------ flatMap ------")
// 중첩된 Subject 헨들링
protocol player {
    var score: BehaviorSubject<Int> { get }
}

struct Archer: player {
    var score: BehaviorSubject<Int>
}

let 🇰🇷player = Archer(score: BehaviorSubject<Int>(value: 10))
let 🇺🇸player = Archer(score: BehaviorSubject<Int>(value: 8))

let olympic = PublishSubject<player>()

olympic
    .flatMap { player in
        player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

olympic.onNext(🇰🇷player)
🇰🇷player.score.onNext(10)

olympic.onNext(🇺🇸player)
🇰🇷player.score.onNext(10)
🇺🇸player.score.onNext(9)

/*
 ------ flatMap ------
 10
 10
 8
 10
 9
*/

print("------ flatMapLatest ------")
// 가장 최신의 시퀀드에서의 값만 확인하고 생성한다
struct Jumper: player {
    var score: BehaviorSubject<Int>
}

let seoulPlayer = Jumper(score: BehaviorSubject<Int>(value: 7))
let busanPlayer = Jumper(score: BehaviorSubject<Int>(value: 6))

let championship = PublishSubject<player>()

championship
    .flatMapLatest { player in
        player.score
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

championship.onNext(seoulPlayer)
seoulPlayer.score.onNext(9)

championship.onNext(busanPlayer)
seoulPlayer.score.onNext(10)
busanPlayer.score.onNext(8)

/*
 ------ flatMapLatest ------
 7
 9
 6
 8
*/


print("------ materialize and dematerialize ------")
enum Foul: Error {
    case start
}

struct Runner: player {
    var score: BehaviorSubject<Int>
}

let playerA = Runner(score: BehaviorSubject<Int>(value: 0))
let playerB = Runner(score: BehaviorSubject<Int>(value: 1))

let running = BehaviorSubject<player>(value: playerA)

running
    .flatMapLatest { player in
        player.score
            .materialize()
    }
    .filter {
        guard let error = $0.error else {
            return true
        }
        print(error)
        return false
    }
    .dematerialize()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

playerA.score.onNext(1)
playerA.score.onError(Foul.start)
playerA.score.onNext(2)

running.onNext(playerB)

/*
 ------ materialize and dematerialize ------
 next(0)
 next(1)
 error(start)
 next(1)
 
 ------ materialize and dematerialize ------
 0
 1
 start
 1
*/


print("------ 전화번호 11자리 ------")
let input = PublishSubject<Int?>()

let list: [Int] = [1]

input
    .flatMap {
        $0 == nil
            ? Observable.empty()
            : Observable.just($0)
    }
    .map { $0! }
    .skip(while: { $0 != 0 })
    .take(11) // 010-1234-4567
    .toArray()
    .asObservable()
    .map {
        $0.map { "\($0)" }
    }
    .map { numbers in
        var numberList = numbers
        numberList.insert("-", at: 3)
        numberList.insert("-", at: 8)
        let number = numberList.reduce(" ", +)
        return number
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

input.onNext(10)
input.onNext(0)
input.onNext(nil)
input.onNext(1)
input.onNext(0)
input.onNext(4)
input.onNext(1)
input.onNext(nil)
input.onNext(3)
input.onNext(4)
input.onNext(1)
input.onNext(6)
input.onNext(3)
input.onNext(4)
