import Foundation
import RxSwift
import Dispatch

print("--- Just ---")
// just : 오직하나의 엘리멘트만을 포함하는 시퀀스
Observable<Int>.just(1)
    .subscribe(onNext: {
        print($0)
    })

print("--- Of 1 ---")
// Of : 하나 이상의 이벤트들을 포함
Observable<Int>.of(1, 2, 3, 4, 5)
    .subscribe(onNext: {
        print($0)
    })
print("--- Of 2 ---")
// Just 연산자와 동일한 효과이다 하나의 Array를 포함
Observable.of([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

print("--- From ---")
// From : Array만 받아 엘리멘트를 하나씩 꺼내서 방출하게 됩니다.
Observable.from([1, 2, 3, 4, 5])
    .subscribe(onNext: {
        print($0)
    })

// 구독 되기 전에는 아무 동작을 하지 않는다.


print("---- subscribe 1 ----")
// onNext를 이용하지 않으면 어떤 이벤트에 발생하는지 확인해준다.
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }

print("---- subscribe 2 ----")
// onNext와 같은 형식으로 나온다.
Observable.of(1, 2, 3)
    .subscribe {
        if let element = $0.element {
            print(element)
        }
    }


print("---- subscribe 3 ----")
Observable.of(1, 2, 3)
    .subscribe(onNext: {
        print($0)
    })

print("---- empty ----")
// 요소를 하나도 갖고 있지 않는
Observable<Void>.empty()
    .subscribe {
        print($0)
    }
// empty 용도: 즉시 종료, 의도적으로 0개를 리턴하고 싶을 때 사용

print("---- never ----")
// 작동은 하지만 아무것도 내보내지 않는것
// debug를 통해서 확인가능
Observable<Void>.never()
    .debug("never")
    .subscribe(
        onNext: {
            print($0)
        },
        onCompleted: {
            print("Completed")
        }
    )

print("---- range ----")
Observable.range(start: 1, count: 9)
    .subscribe(onNext: {
        print("2*\($0)=\(2*$0)")
    })


print("----- dispose -----")
// 구독을 멈추는것
Observable.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .dispose()

print("----- disposeBag -----")
// DisposeBag을 선언해서
let disposeBag = DisposeBag()

Observable<Int>.of(1, 2, 3)
    .subscribe {
        print($0)
    }
    .disposed(by: disposeBag)
// disposeBag에 넣어 후에 한번에 dispose
// 하나의 생명주기
// Observable이 끝나지 않으면 메모리 누수가 발생할 수 있다.

print("------ create 1 ------")
// 시퀀스 만들기

Observable.create { observer -> Disposable in
    observer.onNext(1)
//    observer.on(.next(1))
    observer.onCompleted()
//    observer.on(.completed)
    observer.onNext(2)
    return Disposables.create()
}
.subscribe {
    print($0)
}
.disposed(by: disposeBag)


print("------ create 2 ------")
enum MyError: Error {
    case anError
}

Observable<Int>.create { observer -> Disposable in
    observer.onNext(1)
    observer.onError(MyError.anError)
    observer.onCompleted()
    observer.onNext(2)
    return Disposables.create()
}
.subscribe(
    onNext: {
        print($0)
    },
    onError: {
        print($0.localizedDescription)
    },
    onCompleted: {
        print("completed")
    },
    onDisposed: {
        print("disposed")
    }
)
.disposed(by: disposeBag)

print("------ deffered ------")
// Observable을 통해 Observable 시퀀스 만들기
Observable.deferred {
    Observable.of(1, 2, 3)
}
.subscribe {
    print(1)
}
.disposed(by: disposeBag)


print("------ deffered 2 ------")
var backOff: Bool = false

let factory: Observable = Observable<String>.deferred {
    backOff = !backOff
    
    if backOff {
        return Observable.of("👍")
    } else {
        return Observable.of("👎")
    }
}

for _ in 0...3 {
    factory.subscribe( onNext: {
        print($0)
    })
        .disposed(by: disposeBag)
}
