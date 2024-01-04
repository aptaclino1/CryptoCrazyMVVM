//
//  ViewController.swift
//  CryptoCrazyMVVM
//
//  Created by Messiah on 12/1/23.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var cryptoTable: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView!
    let cryptoVM = CryptoViewModel()
    let disposeBag = DisposeBag()
    var cryptoList = [Crypto]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupBindings()
        cryptoVM.requestData()
        
    }
    
    private func setupBindings() {
               
               cryptoVM
                    .loading
                    .bind(to: self.indicatorView.rx.isAnimating)
                    .disposed(by: disposeBag)
               
               cryptoVM
                   .error
                   .observe(on: MainScheduler.asyncInstance)
                   .subscribe(onNext: { failure in
                       print(failure)
                   })
                   .disposed(by: disposeBag)
               
                  
               cryptoVM
                   .cryptos
                   .observe(on: MainScheduler.asyncInstance)
                   .bind(to: cryptoTable.rx.items(cellIdentifier: "CryptoCell", cellType: CryptoCell.self)) { (row,item,cell) in
                   cell.item = item
               }
                   .disposed(by: disposeBag)
               
               cryptoTable.rx.modelSelected(Crypto.self).subscribe(onNext: { item in
                   print("SelectedItem: \(item.currency)")
                   }).disposed(by: disposeBag)
               }
           
}

//extension ViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return cryptoList.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CryptoCell", for: indexPath) as! CryptoCell
//        var content = cell.defaultContentConfiguration()
//        content.text = cryptoList[indexPath.row].currency
//        content.secondaryText = cryptoList[indexPath.row].price
//        cell.contentConfiguration = content
//        return cell
//    }
//    
//    
//}
