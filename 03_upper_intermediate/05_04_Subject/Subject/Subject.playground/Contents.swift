import RxSwift

let disposeBag = DisposeBag()

print("------ publishSubject ------")
let publishSubject = PublishSubject<String>()

// subject 생성
publishSubject.onNext("1. 여러분 안녕하세요?")

// 구독자1 생성
let person1 = publishSubject
    .subscribe(onNext: {
        print("첫번째 구독자: \($0)")
    })

// subject 생성
publishSubject.onNext("2. 들리세요?")

// subject 생성
publishSubject.on(.next("3. 안들리시나요?"))

person1.dispose()

// 구독자2 생성
let person2 = publishSubject
    .subscribe(onNext: {
        print("두번째 구독자: \($0)")
    })

// subject 생성
publishSubject.onNext("4. 여보세요")

publishSubject.onCompleted()

publishSubject.onNext("5. 끝났나요?")

person2.dispose()

/*
    ------ publishSubject ------
    2. 들리세요?
    3. 안들리시나요?
    4. 여보세요
*/

publishSubject
    .subscribe{
        print("세번째 구독자:", $0.element ?? $0)
    }
    .disposed(by: disposeBag)

publishSubject.onNext("6. 찍히나요??")

/*
     ------ publishSubject ------
     첫번째 구독자: 2. 들리세요?
     첫번째 구독자: 3. 안들리시나요?
     두번째 구독자: 4. 여보세요
     세번째 구독자: completed
*/


print("------ behaviorSubject ------")
enum SubjectError: Error {
    case error1
}
// 초기값 필요
let behaviorSubject = BehaviorSubject<String>(value: "0. 초기값")
behaviorSubject.onNext("1. 첫번째값")
behaviorSubject.subscribe {
    print("첫번째 구독자: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

//behaviorSubject.onError(SubjectError.error1)

behaviorSubject.subscribe {
    print("두번째 구독자: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

/*
     ------ behaviorSubject ------
     첫번째 구독자:  1. 첫번째값
     첫번째 구독자:  error(error1)
     두번째 구독자:  error(error1)
*/

let value = try? behaviorSubject.value()
print(value)

print("------ ReplySubject ------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 2)

replaySubject.onNext("1. 여러분")
replaySubject.onNext("2. 힘내세요")
replaySubject.onNext("3. 어렵지만")

replaySubject.subscribe {
    print("첫번째 구독자: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.subscribe {
    print("두번째 구독자: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

replaySubject.onNext("4. 할수있어요")
replaySubject.onError(SubjectError.error1)
replaySubject.dispose()

replaySubject.subscribe {
    print("세번째 구독자: ", $0.element ?? $0)
}
.disposed(by: disposeBag)

/*
     ------ ReplySubject ------
     첫번째 구독자:  2. 힘내세요
     첫번째 구독자:  3. 어렵지만
     두번째 구독자:  2. 힘내세요
     두번째 구독자:  3. 어렵지만
     첫번째 구독자:  4. 할수있어요
     두번째 구독자:  4. 할수있어요
     첫번째 구독자:  error(error1)
     두번째 구독자:  error(error1)
     세번째 구독자:  error(Object `RxSwift.(unknown context at $107f86e90).ReplayMany<Swift.String>` was already disposed.)

*/
