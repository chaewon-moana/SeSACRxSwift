//
//  BasicViewController.swift
//  SeSACRxSwift
//
//  Created by cho on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa

class BasicViewController: UIViewController {
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        super.viewDidLoad()
        testInterval()
        testOf()
    }
    deinit {
        print("BasicVC Deinit")
    }
    func testInterval() {
        let interval = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance) //타이머처럼 시간마다 보내는 것, 근데 실무에선 잘 안씀!
        
        let intervalValue = interval
            .subscribe { value in
                print("next - \(value)")
            } onError: { error in
                print("Error")
            } onCompleted: {
                print("Complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag) //영원히 종료되지 않음
             //dispose는 그냥 바로 메모리 정리를 해줌. 이벤트를 전달할 수 없는 상황!

        let intervalValue2 = interval
            .subscribe { value in
                print("value2 next - \(value)")
            } onError: { error in
                print("Error")
            } onCompleted: {
                print("Complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag)
        //근데 일일 히 필요한 시점에 모든 구독을 해제해주는거는 힘들 수 있음
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { //5초뒤까지 self로 disposeBag을 잡고 있음! 그래서 dismiss를 하더라도 deinit이 안되는 것!, disposeBag이 잡혀있다가 처리가 되는 것!
            self.disposeBag = DisposeBag() //인스턴스를 다시 초기화하면서 한번에 처리할 수 있음!
           // self.dismiss(animated: true)
        }
//        
        //5초뒤에 메모리가 정리가 되었으면 좋겠음
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            intervalValue.dispose() //수동으로 메모리 정리
//            intervalValue2.dispose()
//        }
    }
    
    func testJust() {
       Observable.just([1,2,3,4,5]) //Finite , 얘는 of와 다르게 하나의 배열밖에 안됨
            .subscribe { value in
                print(value)
            } onError: { error in
                print("Error")
            } onCompleted: {
                print("Completed") //noti
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag) //메모리 정리
    }
    
    func testOf() {
       Observable.of([1,2,3,4,5], [5,6,7], [121223,434]) //같은 타입의 배열이라면 계속 연달아붙일 수 있음
            .subscribe { value in
                print(value)
            } onError: { error in
                print("Error")
            } onCompleted: {
                print("Completed") //noti
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag) //메모리 정리
    }
    
    func testFrom() {
       Observable.from([1,2,3,4,5])
            .subscribe { value in
                print(value)
            } onError: { error in
                print("Error")
            } onCompleted: {
                print("Completed") //noti
            } onDisposed: {
                print("Disposed")
            }
            .disposed(by: disposeBag) //메모리 정리
    }
    
    
    
}
