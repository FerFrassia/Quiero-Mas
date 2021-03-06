//
//  BabyDataViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 5/13/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import Firebase

class BabyDataViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var name: String?
    var birthday: String?
    var email: String?
    var password: String?
    var babyImg: UIImage?
    
    @IBOutlet weak var babyNameTF: UITextField!
    @IBOutlet weak var babyNickNameTF: UITextField!
    @IBOutlet weak var babyBirthdayTF: UITextField!
    @IBOutlet weak var babyScroll: UIScrollView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var babyImgView: UIImageView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var backArrowImg: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setBabyBirthdayTF()
        setTapGesture()
        setBabyImgCorners()
        setBackArrow()
    }
    
    func setBabyBirthdayTF() {
        babyBirthdayTF.inputView = datePicker
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setBabyImgCorners() {
        babyImgView.layer.cornerRadius = babyImgView.frame.width/2
    }
    
    func setBackArrow() {
        backArrowImg.image = UIImage(named: "Back Arrow")!.withRenderingMode(.alwaysTemplate)
    }
    
    @IBAction func backArrowAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tapGestureHandler() {
        let offSet = CGPoint(x:0, y:0)
        babyScroll.setContentOffset(offSet, animated: true)
        self.view.endEditing(true)
    }
    
    //MARK: - IBAction
    @IBAction func createAccount(_ sender: Any) {
        spinner.startAnimating()
        if babyNameTF.text == "" || babyNickNameTF.text == "" || babyBirthdayTF.text == "" {
            let alert = UIAlertController(title: "",
                                          message: "Faltan completar datos",
                                          preferredStyle: UIAlertControllerStyle.alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                                             style: .cancel, handler: nil)
            
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
            spinner.stopAnimating()
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: { (user, error) in
            if error != nil {
                let alert = UIAlertController(title: "",
                                              message: "No se pudo crear la cuenta, puede que ya exista una cuenta con este email",
                                              preferredStyle: UIAlertControllerStyle.alert)
                
                let cancelAction = UIAlertAction(title: "OK",
                                                 style: .cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                self.spinner.stopAnimating()
                return
            } else {
                self.storeUserDataInUserDefaults()
                FirebaseAPI.storeFirebaseUser(firebaseID: (user?.uid)!,
                                              name: self.name!,
                                              birthday: self.birthday!,
                                              email: self.email!,
                                              babyName: self.babyNameTF.text!,
                                              babyNickName: self.babyNickNameTF.text!,
                                              babyBirthday: self.babyBirthdayTF.text!)
                if self.babyImg != nil {
                    FirebaseAPI.uploadBabyImg(img: self.babyImg!)
                }
                self.showMainVC()
            }
        })
    }
    
    func storeUserDataInUserDefaults() {
        var userDic = [String:[String:String]]()
        if let d = UserDefaults.standard.dictionary(forKey: "perfil") as? [String:[String:String]] {
            userDic = d
        }
        
        if name != nil && name! != "" {
            if userDic["Datos"] == nil {userDic["Datos"] = [String:String]()}
            userDic["Datos"]?["Nombre Completo"] = name!
        }
        
        if birthday != nil && birthday! != "" {
            if userDic["Datos"] == nil {userDic["Datos"] = [String:String]()}
            userDic["Datos"]?["Fecha de Nacimiento"] = birthday!
        }
        
        if email != nil && email! != "" {
            if userDic["Datos"] == nil {userDic["Datos"] = [String:String]()}
            userDic["Datos"]?["Email"] = email!
        }
        
        if babyNameTF.text != nil && babyNameTF.text! != "" {
            if userDic["Bebé"] == nil {userDic["Bebé"] = [String:String]()}
            userDic["Bebé"]?["Nombre"] = babyNameTF.text!
        }
        
        if babyNickNameTF.text != nil && babyNickNameTF.text! != "" {
            if userDic["Bebé"] == nil {userDic["Bebé"] = [String:String]()}
            userDic["Bebé"]?["Apodo"] = babyNickNameTF.text!
        }
        
        if babyBirthdayTF.text != nil && babyBirthdayTF.text! != "" {
            if userDic["Bebé"] == nil {userDic["Bebé"] = [String:String]()}
            userDic["Bebé"]?["Fecha de Nacimiento"] = babyBirthdayTF.text!
        }
        
        UserDefaults.standard.set(userDic, forKey: defPerfil)
    }
    
    @IBAction func datePickerValueChanged(_ sender: Any) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        babyBirthdayTF.text = selectedDate
    }
    
    @IBAction func takePicture(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cámara", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .camera
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Fotos", style: .default, handler: {(action: UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    //MARK: - Picker Controller Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        babyImgView.image = image
        babyImg = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: - Show VC
    func showMainVC() {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let vc = story.instantiateInitialViewController()
        self.present(vc!, animated: false, completion: nil)
    }
    
    //MARK: - TextField Delegate
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        scrollToView(view: textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case babyNameTF:
            babyNickNameTF.becomeFirstResponder()
        case babyNickNameTF:
            babyBirthdayTF.becomeFirstResponder()
        default:
            return true
        }
        return true
    }

    //MARK: - Scroll View Delegate
    func scrollToView(view: UIView) {
        var val:CGFloat = 0
        if DeviceType.IS_IPHONE_6P {
            val = 140
        } else if DeviceType.IS_IPHONE_6 {
            val = 200
        } else {
            val = 340
        }
        let offSet = CGPoint(x: 0, y: min(view.frame.origin.y + view.frame.size.height + 80, val))
        babyScroll.setContentOffset(offSet, animated: true)
    }
    
    //MARK: - Device
    enum UIUserInterfaceIdiom : Int
    {
        case Unspecified
        case Phone
        case Pad
    }
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
    }

}
