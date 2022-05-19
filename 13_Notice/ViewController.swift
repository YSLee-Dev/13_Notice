//
//  ViewController.swift
//  13_Notice
//
//  Created by 이윤수 on 2022/05/10.
//

import UIKit
import FirebaseRemoteConfig

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
    
    var remoteConfig : RemoteConfig?

    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        remoteConfigSet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let remoteConfig = remoteConfig else {
            return
        }

        self.getNotice()
        self.alertBtn.isEnabled = !self.isNoticeHidden(remoteConfig)
    }
    
    private func setView(){
        self.view.addSubview(self.alertBtn)
        NSLayoutConstraint.activate([
            self.alertBtn.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.alertBtn.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.alertBtn.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.alertBtn.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.alertBtn.heightAnchor.constraint(equalToConstant: 20)
        ])
        
    }
    
    private func bgViewUp(){
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
    
    private func remoteConfigSet(){
        self.remoteConfig = RemoteConfig.remoteConfig()
        
        let setting = RemoteConfigSettings()
        setting.minimumFetchInterval = 0 // 테스트를 위해 새로운 값을 가져오는 주기를 줄임
        
        remoteConfig?.configSettings = setting
        remoteConfig?.setDefaults(fromPlist: "RemoteConfigDefaults")
    }
    
    @objc private func alertBtnClick(_ sender:Any){
        self.bgViewUp()
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

// remote config
extension ViewController {
    func getNotice(){
        guard let remoteConfig = self.remoteConfig else {return}
        
        remoteConfig.fetch{ [weak self] status, _ in
            if status == .success {
                remoteConfig.activate(completion: nil)
            }else{
                print("error")
            }
            
            guard let self = self else {return}
            
            if !self.isNoticeHidden(remoteConfig){
                self.bgViewUp()
            
                let popup = PopupViewController()
                popup.delegate = self
                popup.modalPresentationStyle = .overFullScreen
                
                let title = (remoteConfig["title"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detail = (remoteConfig["detail"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                let detailTwo = (remoteConfig["detailTwo"].stringValue ?? "").replacingOccurrences(of: "\\n", with: "\n")
                
                popup.textContents = AlertText(title: title, detail: detail, detailTwo: detailTwo)
                self.present(popup, animated: true)
            }
        }
    }
    
    func isNoticeHidden(_ remoteConfig:RemoteConfig)-> Bool{
        return remoteConfig["isHidden"].boolValue
    }
}
