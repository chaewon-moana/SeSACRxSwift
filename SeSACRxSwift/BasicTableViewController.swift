//
//  BasicTableViewController.swift
//  SeSACRxSwift
//
//  Created by cho on 3/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

//UI -> infinite
//DisposeBag 클래스가 deinit이 될 때, dispose 메소드가 호출됨

class BasicTableViewController: UIViewController {

    let tableView = UITableView()
    let disposeBag = DisposeBag()
    let items = Observable.just([
        "First Item",
        "Second Item",
        "Third Item"
    ])
    
    deinit {
        print("BasicTableVC - deinit")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        items
        .bind(to: tableView.rx.items) { (tableView, row, element) in //diffable이랑 닮아있음!,, rx는 delegate랑 datasource로 기반되어있음
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected
            .subscribe { indexPath in
                print(indexPath)
            } onDisposed: { //cell이 클릭이 될 때는 계속해서 클릭이 되어야지 메모리 정리가 되면 안됨!, 즉 테이블뷰컨이 살아있는 한 계속 떠 있어야함
                print("disposed") //뷰컨이 deinit이 되는 순간이랑 dispose가 되는 순간이 같음!.
            }
            .disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self) //didselectedRowAT 기능을 2개로 나눠서 했음. data를 얻고 싶으면 이렇게 됨!, 각 셀에 들어있는 data type이 이거임!
            .subscribe{ model in
                print(model)
            }
            .disposed(by: disposeBag)
    }

    func configureView() {
        view.backgroundColor = .white
        tableView.backgroundColor = .lightGray
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
