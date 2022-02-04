import RxSwift

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
let school = [
    "classA": Observable.of("👧🏼", "🧒🏻", "👦🏽"),
    "classB":  Observable.of("👶🏾", "👶🏻")
]

Observable.of("classA", "classB")
    .compactMap { classNumber in
        school[classNumber] ?? .empty()
    }
    .subscribe(onNext: {
        print($0)
    })
    .disposed(by: disposeBag)

