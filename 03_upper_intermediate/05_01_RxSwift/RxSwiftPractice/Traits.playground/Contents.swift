import RxSwift

// 사전작업 ( disposeBag, Error 생성 )
let disposeBag = DisposeBag()

enum TraitsError: Error {
    case single
    case maybe
    case completable
}

print("----- Single 1 -----")


