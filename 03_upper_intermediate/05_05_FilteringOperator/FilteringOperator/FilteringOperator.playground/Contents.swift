import RxSwift

let disposeBag = DisposeBag()

print("------ ignoreElements ------")
// next 이벤트를 무시하는 것
let sleepingMode = PublishSubject<String>()

sleepingMode
    .ignoreElements()
    .subscribe { _ in
        print("🌞")
    }
    .disposed(by: disposeBag)

sleepingMode.onNext("⏰")
sleepingMode.onNext("⏰")
sleepingMode.onNext("⏰")

sleepingMode.onCompleted()

/*
 ------ ignoreElements ------
 🌞
*/

print("------ elementAt ------")
// element at 특정 인덱스만 방출
let person = PublishSubject<String>()

person
    .element(at: 2)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

person.onNext("⏰") // index 0
person.onNext("⏰") // index 1
person.onNext("😀") // index 2
person.onNext("⏰") // index 3

/*
 ------ elementAt ------
 😀
*/

print("------ filter ------")
Observable.of(1, 2, 3, 4, 5, 6, 7, 8)
    .filter { $0 % 2 == 0 }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ filter ------
 2
 4
 6
 8
*/


print("------ skip ------")
Observable.of("1", "2", "3", "4", "5", "6")
    .skip(5)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ skip ------
 6
*/


print("------ skipWhile ------")
Observable.of("1", "2", "3", "4", "5", "6", "7")
    .skip(while: {
        $0 != "5"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ skipWhile ------
 5
 6
 7
*/

print("------ skipUntil ------")
let guest = PublishSubject<String>()
let openTime = PublishSubject<String>()

guest // 현재 Observable
    .skip(until: openTime)  // 다른 Observable
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

guest.onNext("😀")
guest.onNext("😀")

openTime.onNext("Open!")
guest.onNext("😎")

/*
 ------ skipUntil ------
 😎
*/

print("------ take ------")
// take 까지만 출력
Observable.of("🥇", "🥈", "🥉", "😀", "😎")
    .take(3)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ take ------
 🥇
 🥈
 🥉
*/

print("------ takeWhile ------")
Observable.of("🥇", "🥈", "🥉", "😀", "😎")
    .take(while: {
        $0 != "🥉"
    })
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ takeWhile ------
 🥇
 🥈
*/


print("------ enumerated ------")
// 방출된 요소의 index을 참고하고 싶을때 사용
Observable.of("🥇", "🥈", "🥉", "😀", "😎")
    .enumerated()
    .takeWhile {
        $0.index < 3
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ enumerated ------
 (index: 0, element: "🥇")
 (index: 1, element: "🥈")
 (index: 2, element: "🥉")
*/

print("------ takeUntil ------")
let signUpForClass = PublishSubject<String>()
let end = PublishSubject<String>()

signUpForClass
    .take(until: end)
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

signUpForClass.onNext("🙋🏻‍♂️")
signUpForClass.onNext("🙋🏼")

end.onNext("끝!")

signUpForClass.onNext("🙋🏻‍♀️")

/*
 ------ takeUntil ------
 🙋🏻‍♂️
 🙋🏼
*/

print("------ distinctUntilChanged ------")
// 연속적인 중복값을 막아주는 역할
Observable.of("저는", "저는", "앵무새", "앵무새", "앵무새", "입니다", "입니다", "입니다", "입니다", "저는", "앵무새", "일까요?", "일까요?")
    .distinctUntilChanged()
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

/*
 ------ distinctUntilChanged ------
 저는
 앵무새
 입니다
 저는
 앵무새
 일까요?
*/
