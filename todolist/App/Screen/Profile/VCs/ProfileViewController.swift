//
//  ProfileViewController.swift
//  todolist
//
//  Created by Mac on 10/4/19.
//  Copyright © 2019 Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
import SVProgressHUD
import OneSignal


final class ProfileViewController: UIViewController {
    
    //MARK:- UI Properties
    
    private let scrollview = UIScrollView()
    private let container = UIView()
    private let datePicker = UIDatePicker()
    private let backgroundView = UIView()
    private let userNameLabel = UILabel()
    private let logOutBtn = UIButton()
    private let profileImage = UIImageView()
    private let emailLabel = UILabel()
    private let firtnameLb = UILabel()
    private let lastnameLb = UILabel()
    private let birthday = UILabel()
    private let aboutLabel = UILabel()
    private let decorateView = UIView()
    private let saveBtn = UIButton()
    private let decoView = UIView()
    private let notiSwitch = UISwitch()
    private let settingLabel = UILabel()
    private let setNotiLabel = UILabel()
    
    private var firstnameTextField = UITextField()
    private var lastnameTextField = UITextField()
    private var birthdayTextField = UITextField()
    
    private var viewModel = ProfileVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initDelegate()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        initUser()
    }
}

//MARK:- Init
extension ProfileViewController {
    final private func initUser(){
        viewModel.resquestUserAPI()
      
    }
    
    final private func initDelegate(){
        viewModel.delegate = self
        firstnameTextField.delegate = self
        lastnameTextField.delegate = self
        birthdayTextField.delegate = self
    }
    
  
}

// MARK:- Setup UI
extension ProfileViewController {
    
    final private func setupUI(){
        setupScroll()
        setupProfileUI()
        setupProfileSetting()
        setupSetting()
        setupLogOutBtn()
        checkSubcribe()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    //MARK: Scroll
    final private func setupScroll(){
        self.view.addSubview(scrollview)
        scrollview.snp.makeConstraints { (make) in
            make.width.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        scrollview.delegate = self
        
        scrollview.backgroundColor = UIColor(red:1.00, green:0.19, blue:0.31, alpha:1.0)
        scrollview.alwaysBounceVertical = true
        scrollview.showsHorizontalScrollIndicator = false
        
        
        scrollview.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.scrollview)
            make.left.right.equalTo(self.scrollview)
            make.width.equalTo(self.scrollview)
            make.height.equalTo(self.scrollview).offset(20)
        }
        
    }
    
    
    final private func setupProfileUI(){
        container.backgroundColor = .white
        container.addSubview(backgroundView)
        
        backgroundView.snp.makeConstraints{ make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(200)
        }
        backgroundView.backgroundColor = UIColor(red:1.00, green:0.19, blue:0.31, alpha:1.0)
        
        
        container.addSubview(userNameLabel)
        
        userNameLabel.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(40)
        }
        userNameLabel.textColor = .white
        userNameLabel.text = ""
        
        
        container.addSubview(profileImage)
        
        profileImage.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
            make.top.equalTo(userNameLabel).offset(45)
        }
        //profileImage.image = UIImage(named: "profile_selected")
        profileImage.layer.cornerRadius = profileImage.frame.width/2
        profileImage.layer.masksToBounds = false
        profileImage.clipsToBounds = true
        profileImage.backgroundColor = .white
        profileImage.contentMode = .scaleAspectFill
        
        
        container.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints{ make in
            make.top.equalTo(profileImage).offset(80)
            make.centerX.equalToSuperview()
        }
        emailLabel.text = "Email"
        emailLabel.textColor = .white
    }
    
    
    
    final private func setupProfileSetting(){
        
        container.addSubview(aboutLabel)
        aboutLabel.snp.makeConstraints { (make) in
            make.top.equalTo(backgroundView.snp.bottom).offset(35)
            make.left.equalToSuperview().offset(46)
            //make.width.equalTo(83)
            make.height.equalTo(21)
        }
        aboutLabel.text = "About"
        aboutLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        
        container.addSubview(firtnameLb)
        firtnameLb.snp.makeConstraints { (make) in
            make.top.equalTo(aboutLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(46)
            //make.width.equalTo(83)
            make.height.equalTo(21)
        }
        firtnameLb.text = "First Name"
        
        
        container.addSubview(firstnameTextField)
        
        firstnameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(firtnameLb.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(46)
            make.right.equalToSuperview().offset(-46)
            make.width.equalTo(322)
            make.height.equalTo(30)
        }
        firstnameTextField.borderStyle = .roundedRect
        
        
        container.addSubview(lastnameLb)
        
        lastnameLb.snp.makeConstraints { (make) in
            make.top.equalTo(firstnameTextField.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(46)
            make.height.equalTo(21)
        }
        lastnameLb.text = "Last Name"
        
        
        container.addSubview(lastnameTextField)
        lastnameTextField.snp.makeConstraints { (make) in
            make.top.equalTo(lastnameLb.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(46)
            make.right.equalToSuperview().offset(-46)
            make.height.equalTo(30)
        }
        lastnameTextField.borderStyle = .roundedRect
        
        
        container.addSubview(birthday)
        
        birthday.snp.makeConstraints { (make) in
            make.top.equalTo(lastnameTextField.snp.bottom).offset(11)
            make.left.equalToSuperview().offset(46)
            make.height.equalTo(21)
        }
        birthday.text = "Birthday"
        
        
        container.addSubview(birthdayTextField)
        
        birthdayTextField.snp.makeConstraints { (make) in
            make.top.equalTo(birthday.snp.bottom).offset(8)
            make.left.equalToSuperview().offset(46)
            make.right.equalToSuperview().offset(-46)
            make.height.equalTo(30)
        }
        birthdayTextField.borderStyle = .roundedRect
        
        //MARK:- save button
        container.addSubview(saveBtn)
        
        saveBtn.snp.makeConstraints{ make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(46)
            make.right.equalToSuperview().offset(-46)
        }
        saveBtn.addTarget(self, action: #selector(saveProfile(_sender:)), for: .touchUpInside)
        saveBtn.setTitle("Save", for: .normal)
        saveBtn.setTitleColor(.white, for: .normal)
        
        saveBtn.backgroundColor = .green
        saveBtn.layer.cornerRadius = 10
        
        container.addSubview(decoView)
        decoView.snp.makeConstraints{ make in
            make.top.equalTo(saveBtn.snp.bottom).offset(15)
            make.width.equalToSuperview()
            make.height.equalTo(1)
        }
        decoView.backgroundColor = .lightGray
        
        showdatePicker()
    }
    
    //MARK:- setup Setting
    final private func setupSetting(){
        container.addSubview(settingLabel)
        settingLabel.snp.makeConstraints{ make in
            make.top.equalTo(saveBtn.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(46)
            make.height.equalTo(21)
        }
        settingLabel.text = "Setting"
        settingLabel.font = UIFont.systemFont(ofSize: 25, weight: .semibold)
        
        container.addSubview(setNotiLabel)
        setNotiLabel.snp.makeConstraints { (make) in
            make.top.equalTo(settingLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(46)
            //make.width.equalTo(83)
            make.height.equalTo(21)
        }
        setNotiLabel.text = "Enable Notification"
        
        container.addSubview(notiSwitch)
        notiSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(settingLabel.snp.bottom).offset(30)
            make.right.equalToSuperview().offset(-46)
            //make.width.equalTo(83)
            make.height.equalTo(21)
        }
        notiSwitch.addTarget(self, action: #selector(onNotiSwitchChange(state:)), for: .valueChanged)
        
    }
    
    //MARK:- Logout Btn
    final private func setupLogOutBtn(){
        container.addSubview(logOutBtn)
        logOutBtn.snp.makeConstraints{ make in
            make.centerX.equalToSuperview()
            make.top.equalTo(setNotiLabel.snp.bottom).offset(20)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        logOutBtn.setTitle("Log Out", for: .normal)
        logOutBtn.setTitleColor(.black, for: .normal)
        logOutBtn.layer.cornerRadius = 10
        logOutBtn.backgroundColor = UIColor(red: 0x00, green: 0x00, blue: 0x00,alpha: 0.1)
        logOutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        logOutBtn.addTarget(self, action: #selector(logOutTapped), for: .touchUpInside)
    }
    
    
    
    private final func showdatePicker() {
        datePicker.datePickerMode = .date
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(canceldatePicker))
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        birthdayTextField.inputAccessoryView = toolbar
        birthdayTextField.inputView = datePicker
    }
    
    
    //    final private func setProfilefromAPI(){
    //        self.userNameLabel.text = User.getNamePrint()
    //        print("username : \(User.getNamePrint())")
    //
    //        self.emailLabel.text = User.getemailPrint()
    //        print("email: \(User.getemailPrint())")
    //    }
    
}

//MARK:- Action functions
extension ProfileViewController {
    
    
    @objc final private func onNotiSwitchChange(state: UISwitch) {
        if state.isOn {
            OneSignal.setSubscription(true)
        } else {
            OneSignal.setSubscription(false)
        }
    }
    
    
    @objc final private func donedatePicker() {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        birthdayTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @objc final private func canceldatePicker() {
        self.view.endEditing(true)
    }
    
    @objc final private func logOutTapped(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            Board.resetBoardCount(value: 0)
            self.tabBarController?.navigationController?.viewControllers = [ViewController()]
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    //MARK: Save Profile
    @objc final private func saveProfile(_sender: UIButton){
        let firstname = firstnameTextField.text
        let lastname = lastnameTextField.text
        let birthday = birthdayTextField.text
        let currentuser = Auth.auth().currentUser
        if currentuser != nil{
            
            updateUserAPI(firstName: firstname!, lastName: lastname!, userPhone: "", birthDay: birthday! , avatarURL: "", email: "")
            _sender.flash()
            
            self.viewModel.setUser(newuser: User(firstName: firstname!, lastName: lastname!, userPhone: "", birthDay: birthday! , avatarURL: "", email: ""))
            SVProgressHUD.show()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
                
                self.viewModel.resquestUserAPI()
            }
            
            SVProgressHUD.dismiss()
        }
        clearTextField()
    }
}
//MARK:- private function
extension ProfileViewController{
    
    //    final private func checkTextField() -> Bool {
    //        if self.firstnameTextField.text == "" || self.lastnameTextField.text == "" || self.birthday.text == "" {
    //            return false
    //        }
    //        return true
    //    }
    
    final private func clearTextField(){
        firstnameTextField.text = ""
        lastnameTextField.text = ""
        birthdayTextField.text = ""
    }
    
    final private func checkSubcribe(){
          let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()
          
          let isSubscribed = status.subscriptionStatus.subscribed
          print("isSubscribed = \(isSubscribed)")
          
          if isSubscribed == true {
              notiSwitch.setOn(true, animated: true)
          }
      }
    
    final private func inflateFromVM(){
        userNameLabel.text = viewModel.getUserFirstName() + " " + viewModel.getUserLastName()
        emailLabel.text = viewModel.getUserEmail()
        firstnameTextField.placeholder = viewModel.getUserFirstName()
        lastnameTextField.placeholder = viewModel.getUserLastName()
        birthdayTextField.placeholder = viewModel.getUserBirth()
    }
}

//MARK:- profileVM delegate
extension ProfileViewController: ProfileVMdelegate {
    func onProfileChangeData(_ vm: ProfileVM, data: User) {
        inflateFromVM()
    }
}

extension ProfileViewController: UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
        
    }
}

extension ProfileViewController: UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset = CGPoint(x: 0, y: self.scrollview.contentOffset.y)
        scrollView.isDirectionalLockEnabled = true
        
    }
}
