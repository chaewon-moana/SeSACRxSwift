//
//  BasicButtonViewController.swift
//  SeSACRxSwift
//
//  Created by cho on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BasicButtonViewController: UIViewController {

    let button = UIButton()
    let label = UILabel()
    let textField = UITextField()
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        let test = textField
            .rx //Reactive<UITextField>
            .text //ControlProperty<String?>
            .orEmpty //ControlProperty<String>, 옵셔널을 제거해줌
            .map { $0.count } //Observable<Int>
            .map { $0 > 4 } //Observable<Bool> //여기까지가 Observable
            .bind { value in //마지막 stream값이 클로저로 전달됨
                self.button.backgroundColor = value ? .red : .blue
            }
            .disposed(by: bag)
        
        
        
        
        
        
        
        
        //observable: 버튼 탭
        //observer: 레이블에 텍스트
        
        //.찍으면서 sequecne가 바뀜, rx의 대부분은 closure로 이루어져있음, 그래서 생각보다 메모리 누수가 많이 일어남! 잘 잡아야함!
//        button //UIButton -> rx랑은 상관없는애!
//            .rx //rx스럽게 매핑을 도와주는 애! 그럼 Reactive<UIButton>이 됨!
//            .tap //ControlEvent<Void>로 바뀜
//            .subscribe { _ in //next이벤트가 처음 클로저, 클로저 구문이 Observer, 그걸 subscribe로 연결
//                self.label.text = "버튼이 클릭되었습니다."
////            } onError: { _ in
////                print("Error")
////            } onCompleted: {
////                print("completed")
////            } onDisposed: {
////                print("Disposed")
//            }
//            .disposed(by: bag)
        
        button.rx.tap
            .subscribe { _ in //next이벤트가 처음 클로저, 클로저 구문이 Observer, 그걸 subscribe로 연결
                self.label.text = "버튼이 클릭되었습니다."
                
                self.present(BasicViewController(), animated: true)
                
            }
            .disposed(by: bag)
        
//        button.rx.tap
//            .bind { _ in //next 하나만 갖구 있어! 라는 의미
//                self.label.text = "버튼이 클릭되었습니다"
//            }
//            .disposed(by: bag)
    }
    
    func configureView() {
        view.backgroundColor = .white

        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(textField)
        
        button.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        label.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        textField.snp.makeConstraints { make in
            make.top.equalTo(label.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(50)
        }
        
        button.setTitle("테스트버튼", for: .normal)
        button.backgroundColor = .lightGray
        label.text = "테스트라벨테스트라벨"
        textField.placeholder = "텍스트필드"
    }
}
