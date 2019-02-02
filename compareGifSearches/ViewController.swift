//
//  ViewController.swift
//  compareGifSearches
//
//  Created by Michael Bielodied on 1/29/19.
//  Copyright © 2019 Michael Bielodied. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AlamofireImage
import PKHUD

class ViewController: UIViewController {

    //MARK : - variables
    fileprivate let disposeBag = DisposeBag()
    fileprivate let placeholder = UIImage(named: "gifPlaceholder")
    
    //MARK : - outlets
    @IBOutlet weak var firstSearchField: UITextField!
    @IBOutlet weak var secondSearchField: UITextField!
    @IBOutlet weak var firstGifImageView: UIImageView! {
        didSet {
            firstGifImageView.image = placeholder
        }
    }
    @IBOutlet weak var secondGifImageView: UIImageView! {
        didSet {
            secondGifImageView.image = placeholder
        }
    }
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var compareBtn: UIButton! {
        didSet {
            compareBtn.setTitleColor(UIColor.lightGray, for: .disabled)
            compareBtn.setTitleColor(UIColor.blue, for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        bindUI()
    }

}

extension ViewController {
    
    func bindUI() {
        
        Observable.combineLatest(firstSearchField.rx.text, secondSearchField.rx.text, resultSelector: { firstSearchValue, secondSearchValue in
            
            guard let firstSearchValue = firstSearchValue, let secondSearchValue = secondSearchValue else {
                return
            }
            
            self.compareBtn.isEnabled = false
            self.errorLabel.text = ""
            
            if !firstSearchValue.isValidForQuery() || !secondSearchValue.isValidForQuery() {
                self.errorLabel.text = "Only lettres and digits allowed"
                return
            }
 
            self.compareBtn.isEnabled = true
            
            guard let _firstSearchField = self.firstSearchField, let _secondSearchField = self.secondSearchField, let _compareBtn = self.compareBtn else {
                return
            }
            
            let _ = _compareBtn.rx.tap
                .bind {
                    HUD.show(.progress)
            }
            
            // 1
            let viewModel = ViewModel(
                leftQuery: _firstSearchField.rx.text.asObservable(),
                rightQuery: _secondSearchField.rx.text.asObservable(),
                didPressButton: _compareBtn.rx.tap.asObservable()
            )
        
            // 2
            viewModel.compareResponse
            .subscribe(onNext: { [weak self] response in
                
                HUD.hide()
                guard let self = self else {
                    return
                }
                
                print("response \(response)")
                if let _leftURL = response.gifLeftUrl {
                    self.firstGifImageView.af_setImage(withURL: _leftURL)
                } else {
                    self.firstGifImageView.image = self.placeholder
                }
                
                if let _rightURL = response.gifRightUrl {
                    self.secondGifImageView.af_setImage(withURL: _rightURL)
                } else {
                    self.secondGifImageView.image = self.placeholder
                }
                
            }, onError: { [weak self] error in
                print("error")
                
                HUD.hide()
                guard let self = self else {
                    return
                }
                
                Alert.showRequestError(on: self, errorMsg: error.localizedDescription)
            }, onCompleted: {
                print("on completed")
                
                //hide HUD
                
            }, onDisposed: {
                print("on disposed")
            })
                .disposed(by: self.disposeBag)
            
        })
            .subscribe()
        .disposed(by: disposeBag)//to be sure that all data will be released after closing the VC
   
    }
}
