//
//  ViewController.swift
//  13_Notice
//
//  Created by 이윤수 on 2022/05/10.
//

import UIKit

class ViewController: UIViewController {
    
    var alertBtn : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("팝업창 띄우기", for: .normal)
        btn.addTarget(self, action: #selector(alertBtnClick(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    func setView(){
        self.view.addSubview(self.alertBtn)
        NSLayoutConstraint.activate([
            self.alertBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.alertBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.alertBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.alertBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.alertBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    func bgViewUp(){
        self.view.addSubview(self.bgView)
        NSLayoutConstraint.activate([
            self.bgView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.bgView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.bgView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.bgView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3, delay: 0){
                self.bgView.alpha = 0.4
            }
        }
    }
    
    @objc func alertBtnClick(_ sender:Any){
        bgViewUp()
        let popup = PopupViewController()
        popup.delegate = self
        popup.modalPresentationStyle = .overFullScreen
        self.present(popup, animated: true)
    }
}

extension ViewController : PopupClose{
    func btnClick() {
        UIView.animate(withDuration: 0.3, delay: 0){
            self.bgView.alpha = 0
        }
        self.bgView.removeFromSuperview()
    }
}
