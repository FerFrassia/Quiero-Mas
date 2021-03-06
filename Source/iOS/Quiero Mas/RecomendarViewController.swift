//
//  RecomendarViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 5/15/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import SWRevealViewController
import QuartzCore

class RecomendarViewController: UIViewController, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var revealMenuButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    
    var dic = ["0":""]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRevealMenuButton()
        setAppMainColor()
        setTapGesture()
        setObservers()
    }
    
    func setRevealMenuButton() {
        revealMenuButton.target = self.revealViewController()
        revealMenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
    
    func setAppMainColor() {
        view.backgroundColor = appMainColor
    }
    
    func setTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureHandler))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func setObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.recomendarSentAlert), name: NSNotification.Name(rawValue: recomendarSent), object: nil)
    }
    
    func tapGestureHandler() {
        self.view.endEditing(true)
    }
    
    
    //MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendarTableViewCell", for: indexPath) as! RecomendarTableViewCell
        
        cell.emailTF.tag = indexPath.row
        cell.emailTF.text = dic[String(indexPath.row)]
        
        return cell
    }
    
    
    //MARK: - UITextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let oldText = textField.text {
            let newString = oldText + string
            let key = String(textField.tag)
            dic[key] = newString
        }
        return true
    }
    
    
    //MARK: - IBAction
    @IBAction func addCell(_ sender: Any) {
        let i = dic.count
        dic[String(i)] = ""
        UIView.animate(withDuration: 0.2, animations: {
            self.table.reloadData()
        })
    }
    
    @IBAction func send(_ sender: Any) {
        var mails = [String]()
        for (_, element) in dic {
            mails.append(element)
        }
        FirebaseAPI.recomendar(mails: mails)
    }
    
    func eraseEmails() {
        dic = ["0":""]
        UIView.animate(withDuration: 0.2, animations: {
            self.table.reloadData()
        })
    }
    
    
    //MARK: - Observers
    func recomendarSentAlert() {
        showAlert(text: "Tus invitaciones se enviaron exitosamente")
        eraseEmails()
    }


    //MARK: - Aux
    func showAlert(text: String) {
        let alert = UIAlertController(title: "",
                                      message: text,
                                      preferredStyle: UIAlertControllerStyle.alert)
        
        let cancelAction = UIAlertAction(title: "OK",
                                         style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        return
    }







}
