//
//  PopupViewController.swift
//  13_Notice
//
//  Created by 이윤수 on 2022/05/11.
//

import UIKit

protocol PopupClose{
    func btnClick()
}

class PopupViewController : UIViewController {
    
    var popupView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 15
        return view
    }()
    
    var stackView : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 30
        return stack
    }()
    
    var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 27)
        label.text = "공지사항"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "공지내용"
        label.textAlignment = .center
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var detailTwoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "공지내용2(일시)"
        label.textAlignment = .center
        label.numberOfLines = .max
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var closeBtn : UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("닫기", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.layer.cornerRadius = 15
        btn.backgroundColor = UIColor(red: 0.5333, green: 0.8863, blue: 0.5843, alpha: 1.0)
        btn.addTarget(self, action: #selector(closeBtnClick(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var textContents : AlertText?
    
    var delegate : PopupClose?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewSet()
        textSet()
    }
    
    func viewSet(){
        self.view.backgroundColor = .clear
        
        self.view.addSubview(self.popupView)
        NSLayoutConstraint.activate([
            self.popupView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 10),
            self.popupView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.popupView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
        ])
        
        self.popupView.addSubview(self.stackView)
        NSLayoutConstraint.activate([
            self.stackView.topAnchor.constraint(equalTo: self.popupView.topAnchor, constant: 20),
            self.stackView.bottomAnchor.constraint(equalTo: self.popupView.bottomAnchor, constant: -40),
            self.stackView.leadingAnchor.constraint(equalTo: self.popupView.leadingAnchor, constant: 10),
            self.stackView.trailingAnchor.constraint(equalTo: self.popupView.trailingAnchor, constant: -10)
        ])
        
        self.stackView.addArrangedSubview(self.titleLabel)
        self.stackView.addArrangedSubview(self.detailLabel)
        self.stackView.addArrangedSubview(self.detailTwoLabel)
        self.stackView.addArrangedSubview(self.closeBtn)
        NSLayoutConstraint.activate([
            self.closeBtn.leadingAnchor.constraint(equalTo: self.stackView.leadingAnchor),
            self.closeBtn.trailingAnchor.constraint(equalTo: self.stackView.trailingAnchor),
            self.closeBtn.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func textSet(){
        guard let textContents = textContents else {return}

        self.titleLabel.text = textContents.title
        self.detailLabel.text = textContents.detail
        self.detailTwoLabel.text = textContents.detailTwo
    }
    
    @objc func closeBtnClick(_ sender:Any){
        self.dismiss(animated: true)
        self.delegate?.btnClick()
    }
}
