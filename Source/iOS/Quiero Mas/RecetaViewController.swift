//
//  RecetaViewController.swift
//  Quiero Mas
//
//  Created by Fernando N. Frassia on 6/5/17.
//  Copyright © 2017 Fernando N. Frassia. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import Firebase

class RecetaViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var table: UITableView!
    
    //Video
    @IBOutlet weak var thumbnailImgView: UIImageView!
    
    //Top
    @IBOutlet weak var recetaTitle: UILabel!
    
    //Bottom
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    @IBOutlet weak var thirdImg: UIImageView!
    @IBOutlet weak var fourthImg: UIImageView!
    @IBOutlet weak var fifthImg: UIImageView!
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    @IBOutlet weak var tipsViewHeight : NSLayoutConstraint!
    
    //Variante
    @IBOutlet weak var varianteLabel: UILabel!
    @IBOutlet weak var varianteHeightConstraint: NSLayoutConstraint!
    
    //Postre
    @IBOutlet weak var postreView: UIView!
    @IBOutlet weak var postreViewHeight : NSLayoutConstraint!
    
    //Tip Desarrollo
    @IBOutlet weak var tipDesarrolloView: UIView!
    @IBOutlet weak var tipDesarrolloViewHeight : NSLayoutConstraint!
    
    // Receta
    @IBOutlet weak var recetaView : UIView!
    @IBOutlet weak var reutilizarViewPosition : NSLayoutConstraint!
    
    //Volver a cocinar
    @IBOutlet weak var reutilizarLabel: UILabel!
    @IBOutlet weak var volverACocinarLabel: UILabel!
    
    @IBOutlet weak var puntosView: UIView!
    
    
    var recetaDict: [String:Any]?
    var recetaNombre: String?
    var recetaPostre: [String:Any]?
    var recetaDia: [String:Any]?
    var volverACocinar: String?

    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavBar()
        setTable()
        setCongelarLabel()
    }

    func setNavBar() {
        self.navigationController?.navigationBar.topItem?.title = ""
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setTable() {
        table.register(UINib(nibName: "IngredientesTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "IngredientesTableViewCell")
        table.register(UINib(nibName: "PasosTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "PasosTableViewCell")
    }
    
    func setCongelarLabel() {
        if DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS {
            reutilizarLabel.font = UIFont(name: "Cera-Bold", size: 13)
        }
    }
    
    
    //MARK: - View Will Appear
    override func viewWillAppear(_ animated: Bool) {
        setTop()
        setVideo()
        setVariante()
        setBottom()
        setPuntaje()
        showOrHideViews()
        setVolverACocinar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showOrHideViews()
//            self.table.reloadData()
//        }
    }
    
    func setTop() {
        recetaTitle.text = recetaNombre
    }
    
    func setVideo() {
        if let thumbnail = recetaDict?[firRecetaThumbnail] as? String {
            thumbnailImgView.sd_setImage(with: URL(string:thumbnail), placeholderImage: UIImage(named: "Thumbnail Receta"))
        }
    }
    
    func setVariante() {
        if recetaDict?[firRecetaVariante] != nil {
            varianteLabel.text = recetaDict?[firRecetaVariante] as? String
        }
    }
    
    func setBottom() {
        setVarianteView()
        bottomView.frame = CGRect(origin: bottomView.frame.origin, size: CGSize(width: bottomView.frame.size.width, height:varianteHeightConstraint.constant + 387))
    }
    
    func setPuntaje() {
        if let puntajeDic = recetaDict?[firRecetaPuntaje] as? [String:Any] {
            if let datosDic = puntajeDic[firRecetaPuntajeDatos] as? [String:Int] {
                let user = FIRAuth.auth()?.currentUser
                guard let firebaseID = user?.uid else {return}
                if let puntaje = datosDic[firebaseID] {
                    dibujarPuntaje(puntaje: puntaje)
                }
            }
        } else {
            dibujarPuntaje(puntaje: 0)
        }
    }
    
    func showOrHideViews() {
        showOrHidePostre()
        showOrHideTipDesarrollo()
        if tipDesarrolloView.isHidden {
            self.tipsViewHeight.constant = self.recetaView.frame.origin.y + self.recetaView.frame.size.height + 20
        } else {
            self.tipsViewHeight.constant = self.tipDesarrolloView.frame.origin.y + self.tipDesarrolloViewHeight.constant + 20
        }
    }

    func showOrHidePostre() {
        postreView.isHidden = recetaPostre == nil
        if postreView.isHidden {
            self.postreViewHeight.constant = 0
            self.reutilizarViewPosition.constant = 0
        }
    }

    func showOrHideTipDesarrollo() {
        tipDesarrolloView.isHidden = recetaDia == nil
        if tipDesarrolloView.isHidden {
            self.tipDesarrolloViewHeight.constant = 0
        }
    }
    
    func setVolverACocinar() {
        volverACocinarLabel.text = volverACocinar
    }
    
    func setVarianteView() {
        var val = 0
        if DeviceType.IS_IPHONE_6P {
            val = 20
        } else if DeviceType.IS_IPHONE_6 {
            val = 40
        } else {
            val = 80
        }
        if let labelHeight = varianteLabel.text?.height(withConstrainedWidth: varianteLabel.frame.width, font: varianteLabel.font) {
            let viewHeight = varianteLabel.frame.origin.y + labelHeight + CGFloat(val)
            varianteHeightConstraint.constant = viewHeight
        }
    }
    
    
    //MARK: - UITableView Data Source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var sections = 0
        if section == 0 {
            if let ingredientesArr = recetaDict?[firRecetaIngredientes] as? [[String:Any]] {
                sections = ingredientesArr.count
            }
        } else {
            if let pasosArr = recetaDict?[firRecetaPasos] as? [String] {
                sections = pasosArr.count
            }
        }
        
        return sections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientesTableViewCell", for: indexPath) as! IngredientesTableViewCell
            
            if let ingredientesArr = recetaDict?[firRecetaIngredientes] as? [[String:Any]] {
            let ingredienteDic = ingredientesArr[indexPath.row]
            cell.title.text = ingredienteDic[firRecetaIngredientesNombre] as? String
            
            if ingredienteDic[firRecetaIngredientesNombreBasico] != nil {
                    cell.title.font = UIFont(name: "Cera-Bold", size: 16)
                    cell.title.textColor = appMainColor
            }
            cell.button.isHidden = ingredienteDic[firRecetaIngredientesNombreBasico] == nil
                
            }
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PasosTableViewCell", for: indexPath) as! PasosTableViewCell
            
            cell.numberLabel.text = String(indexPath.row + 1)
            if let pasosArr = recetaDict?[firRecetaPasos] as? [String] {
                cell.title.text = pasosArr[indexPath.row]
                cell.title.scrollRangeToVisible(NSMakeRange(0, 0))
            }
            
            return cell
        }
    }
    
    
    //MARK: - UITableView Delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        if indexPath.section == 0 {
            height = 44
        } else {
            if DeviceType.IS_IPHONE_6P {
                height = 85
            } else if DeviceType.IS_IPHONE_6 {
                height = 85
            } else {
                height = 88
            }
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var text = ""
        if section == 0 {
            text = "     INGREDIENTES PARA 1 PORCIÓN"
        } else {
            text = "     PASO A PASO"
        }
        
        let label = UILabel()
        label.backgroundColor = .white
        label.text = text
        label.font = UIFont(name: "Cera-Bold", size: 16)
        
        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let ingredientesArr = recetaDict?[firRecetaIngredientes] as? [[String:Any]] {
                let ingredienteDic = ingredientesArr[indexPath.row]
                if ingredienteDic[firRecetaIngredientesNombreBasico] != nil {
                    performSegue(withIdentifier: "recetaBasicaSegue", sender: ingredienteDic[firRecetaIngredientesNombreBasico])
                }
            }
        }
    }
    
    
    //MARK: - IBAction Top
    @IBAction func tipNutricionalAction(_ sender: UIButton) {
        performSegue(withIdentifier: "tipNutricionalSegue", sender: self)
    }
    
    
    //MARK: - IBAction Bottom
    @IBAction func postreAction(_ sender: UIButton) {
        performSegue(withIdentifier: "postreSegue", sender: self)
    }
    
    @IBAction func tipDesarrolloAction(_ sender: UIButton) {
        performSegue(withIdentifier: "tipDesarrolloSegue", sender: self)
    }
    
    @IBAction func conservacionAction(_ sender: UIButton) {
        performSegue(withIdentifier: "conservacionSegue", sender: self)
    }
    
    @IBAction func firstAction(_ sender: UIButton) {
        dibujar1()
        if recetaNombre != nil {UserDefaultsManager.setearPuntajeEnUserDefaults(recetaNombre: recetaNombre!, puntaje: 1)}
        if recetaNombre != nil {FirebaseAPI.puntuar(receta: recetaNombre!, puntuacion: 1)}
    }
    
    @IBAction func secondAction(_ sender: UIButton) {
        dibujar2()
        if recetaNombre != nil {UserDefaultsManager.setearPuntajeEnUserDefaults(recetaNombre: recetaNombre!, puntaje: 2)}
        if recetaNombre != nil {FirebaseAPI.puntuar(receta: recetaNombre!, puntuacion: 2)}
    }
    
    @IBAction func thirdAction(_ sender: UIButton) {
        dibujar3()
        if recetaNombre != nil {UserDefaultsManager.setearPuntajeEnUserDefaults(recetaNombre: recetaNombre!, puntaje: 3)}
        if recetaNombre != nil {FirebaseAPI.puntuar(receta: recetaNombre!, puntuacion: 3)}
    }
    
    @IBAction func fourthAction(_ sender: UIButton) {
        dibujar4()
        if recetaNombre != nil {UserDefaultsManager.setearPuntajeEnUserDefaults(recetaNombre: recetaNombre!, puntaje: 4)}
        if recetaNombre != nil {FirebaseAPI.puntuar(receta: recetaNombre!, puntuacion: 4)}
    }
    
    @IBAction func fifthAction(_ sender: UIButton) {
        dibujar5()
        if recetaNombre != nil {UserDefaultsManager.setearPuntajeEnUserDefaults(recetaNombre: recetaNombre!, puntaje: 5)}
        if recetaNombre != nil {FirebaseAPI.puntuar(receta: recetaNombre!, puntuacion: 5)}
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        if let videoString = recetaDict?[firRecetaVideo] as? String {
            let videoURL = URL(string: videoString)
            let player = AVPlayer(url: videoURL!)
            let playerViewController = LandscapeAVPlayerController()
            playerViewController.player = player
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    //MARK: - Puntaje
    func dibujar0() {
        firstImg.image = UIImage(named: "Oval Vacio")
        firstLabel.textColor = appMainColor
        secondImg.image = UIImage(named: "Oval Vacio")
        secondLabel.textColor = appMainColor
        thirdImg.image = UIImage(named: "Oval Vacio")
        thirdLabel.textColor = appMainColor
        fourthImg.image = UIImage(named: "Oval Vacio")
        fourthLabel.textColor = appMainColor
        fifthImg.image = UIImage(named: "Oval Vacio")
        fifthLabel.textColor = appMainColor
    }
    
    func dibujar1() {
        firstImg.image = UIImage(named: "Oval Lleno")
        firstLabel.textColor = .white
        
        secondImg.image = UIImage(named: "Oval Vacio")
        secondLabel.textColor = appMainColor
        thirdImg.image = UIImage(named: "Oval Vacio")
        thirdLabel.textColor = appMainColor
        fourthImg.image = UIImage(named: "Oval Vacio")
        fourthLabel.textColor = appMainColor
        fifthImg.image = UIImage(named: "Oval Vacio")
        fifthLabel.textColor = appMainColor
    }
    
    func dibujar2() {
        secondImg.image = UIImage(named: "Oval Lleno")
        secondLabel.textColor = .white
        
        firstImg.image = UIImage(named: "Oval Vacio")
        firstLabel.textColor = appMainColor
        thirdImg.image = UIImage(named: "Oval Vacio")
        thirdLabel.textColor = appMainColor
        fourthImg.image = UIImage(named: "Oval Vacio")
        fourthLabel.textColor = appMainColor
        fifthImg.image = UIImage(named: "Oval Vacio")
        fifthLabel.textColor = appMainColor
    }
    
    func dibujar3() {
        thirdImg.image = UIImage(named: "Oval Lleno")
        thirdLabel.textColor = .white
        
        firstImg.image = UIImage(named: "Oval Vacio")
        firstLabel.textColor = appMainColor
        secondImg.image = UIImage(named: "Oval Vacio")
        secondLabel.textColor = appMainColor
        fourthImg.image = UIImage(named: "Oval Vacio")
        fourthLabel.textColor = appMainColor
        fifthImg.image = UIImage(named: "Oval Vacio")
        fifthLabel.textColor = appMainColor
    }
    
    func dibujar4() {
        fourthImg.image = UIImage(named: "Oval Lleno")
        fourthLabel.textColor = .white
        
        firstImg.image = UIImage(named: "Oval Vacio")
        firstLabel.textColor = appMainColor
        secondImg.image = UIImage(named: "Oval Vacio")
        secondLabel.textColor = appMainColor
        thirdImg.image = UIImage(named: "Oval Vacio")
        thirdLabel.textColor = appMainColor
        fifthImg.image = UIImage(named: "Oval Vacio")
        fifthLabel.textColor = appMainColor
    }
    
    func dibujar5() {
        fifthImg.image = UIImage(named: "Oval Lleno")
        fifthLabel.textColor = .white
        
        firstImg.image = UIImage(named: "Oval Vacio")
        firstLabel.textColor = appMainColor
        secondImg.image = UIImage(named: "Oval Vacio")
        secondLabel.textColor = appMainColor
        thirdImg.image = UIImage(named: "Oval Vacio")
        thirdLabel.textColor = appMainColor
        fourthImg.image = UIImage(named: "Oval Vacio")
        fourthLabel.textColor = appMainColor
    }
    
    func dibujarPuntaje(puntaje: Int) {
        switch puntaje {
        case 0:
            dibujar0()
        case 1:
            dibujar1()
        case 2:
            dibujar2()
        case 3:
            dibujar3()
        case 4:
            dibujar4()
        case 5:
            dibujar5()
        default:
            print("dibujar puntaje mal llamado")
        }
    }
    
    
    //MARK: - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tipDesarrolloSegue" {
            let vc = segue.destination as! TipDesarrolloViewController
            vc.texto = recetaDia?[firPorEdadDesarrollo] as? String
        }
        
        if segue.identifier == "tipNutricionalSegue" {
            let vc = segue.destination as! TipNutricionalViewController
            if let texto = recetaDict?[firRecetaTipNutricional] as? String {
                vc.texto = texto
            }
        }
        
        if segue.identifier == "recetaBasicaSegue" {
            let vc = segue.destination as! RecetaBasicaViewController
            if let basicaName = sender as? String {
                if let basicasDict = UserDefaults.standard.dictionary(forKey: "recetas basicas") {
                    vc.basicaNombre = basicaName
                    vc.basicaDict = basicasDict[basicaName] as? [String:Any]
                }
            }
        }
    
        if segue.identifier == "postreSegue" {
            let vc = segue.destination as! PostreViewController
            vc.basicaDict = recetaPostre
        }
    }
    
}

class LandscapeAVPlayerController: AVPlayerViewController {
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .landscapeRight
    }
}
