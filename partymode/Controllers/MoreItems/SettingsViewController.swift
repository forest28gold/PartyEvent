//
//  SettingsViewController.swift
//  partymode
//
//  Created by AppsCreationTech on 1/14/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import AudioToolbox

class SettingsViewController: UIViewController {

    @IBOutlet weak var vibration_switch: UISwitch!
    
    @IBOutlet weak var vibrateLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var englishButton: UIButton!
    @IBOutlet weak var germanButton: UIButton!
    
    var flag = true
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfGotoHomeView(_:)), name:NSNotification.Name(rawValue: "notificationId_gotoPartyPeopleTab"), object: nil)
        
    }
    
    func methodOfGotoHomeView(_ notification: Notification){
        //Take Action on Notification
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController];
        self.navigationController!.popToViewController(viewControllers[viewControllers.count - 2], animated: false);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        
        vibrateLabel.text = NSLocalizedString("vibrate", comment: "")
        logoutButton.setTitle(NSLocalizedString("logoff", comment: ""), for: UIControlState())
        logoutButtonStyle()
        
        let vibrate_status = UserDefaults.standard.bool(forKey: "vibrate")
        vibration_switch.setOn(vibrate_status, animated: false)
        
        languageLabel.text = NSLocalizedString("Language", comment:"")
        englishButton.titleLabel?.text = NSLocalizedString("English", comment:"")
        germanButton.titleLabel?.text = NSLocalizedString("German", comment:"")
        
        
        let curLangs = UserDefaults.standard.array(forKey: "AppleLanguages")
        var curLang = "en"
        if curLangs != nil {
            curLang = (curLangs?[0] as? String)!
        }
        
        
        if curLang.contains("en") {
            self.englishButton.setImage(UIImage(named: "ico_on"), for: .normal)
            self.germanButton.setImage(UIImage(named: "ico_off"), for: .normal)
        }
        else {
            self.englishButton.setImage(UIImage(named: "ico_off"), for: .normal)
            self.germanButton.setImage(UIImage(named: "ico_on"), for: .normal)
        }
        
        self.displayAppVersionInfo()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAppVersionInfo(){
        if let versionNumber = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            self.versionLabel.text = "Version \(versionNumber)"
        }
        
    }
    
    func logoutButtonStyle(){
        logoutButton.layer.cornerRadius = 5
        logoutButton.layer.borderColor = UIColor.black.cgColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.masksToBounds = true
    }
    
    func initLoginValues(){
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: "sid")
        defaults.set(nil, forKey: "uid")
        defaults.synchronize()
    }
    
    func gotoLoginScreen(){
        
        _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
    
    @IBAction func switchTouchEvent(_ sender: UISwitch) {
        
        let defaults = UserDefaults.standard
        if sender.isOn {
            defaults.set(true, forKey: "vibrate")
            defaults.synchronize()
            if #available(iOS 10.0, *) {
                let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
                feedbackGenerator.impactOccurred()
            } else {
                // Fallback on earlier versions
            }
            
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        else {
            defaults.set(false, forKey: "vibrate")
            
        }
    }
    
    func enableVibrateOnNotifications(){
        if #available(iOS 10.0, *) {
            let generator = UIImpactFeedbackGenerator(style: .heavy)
            generator.impactOccurred()
        } else {
            // Fallback on earlier versions
        }
        
    }

    @IBAction func logoutPressed(_ sender: Any) {
        
        self.initLoginValues()
        self.gotoLoginScreen()
    }
    
    
    @IBAction func englishButtonTapped(_ sender: Any) {
        
        //UserDefaults.standard.set([language], forKey: "AppleLanguages")
        let curLangs = UserDefaults.standard.array(forKey: "AppleLanguages")
        var curLang = "en"
        if curLangs != nil {
            curLang = (curLangs?[0] as? String)!
        }
        
        
        if curLang.contains("de") {
            let alertController = UIAlertController(title: NSLocalizedString("ChangeLanguage", comment:""), message: NSLocalizedString("ChangeLngEng_msg", comment:""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert_No", comment:""), style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(cancelAction)
            
            
            let OKAction = UIAlertAction(title: NSLocalizedString("alert_yes", comment:""), style: .default) { (action:UIAlertAction!) in
                let selectedLanguage = "en"
                self.englishButton.setImage(UIImage(named: "ico_on"), for: .normal)
                self.germanButton.setImage(UIImage(named: "ico_off"), for: .normal)
                LanguageManger.shared.setLanguage(language: selectedLanguage)
                GlobalData.logined = true
                self.gotoLoginScreen()
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }else {
            self.englishButton.setImage(UIImage(named: "ico_on"), for: .normal)
        }
        
        
//        Language = "Language";
//        English = "English";
//        German = "German";
//        ChangeLanguage = "Change language";
//        ChangeLngGer_msg = "Would you like to change the language to German";
//        ChangeLngEng_msg = "Would you like to change the language to English";
    }
    
    
    @IBAction func germanButtonTapped(_ sender: Any) {
        let curLangs = UserDefaults.standard.array(forKey: "AppleLanguages")
        var curLang = "en"
        if curLangs != nil {
            curLang = (curLangs?[0] as? String)!
        }
        
        if curLang.contains("en") {
            let alertController = UIAlertController(title: NSLocalizedString("ChangeLanguage", comment:""), message: NSLocalizedString("ChangeLngGer_msg", comment:""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert_No", comment:""), style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: NSLocalizedString("alert_yes", comment:""), style: .default) { (action:UIAlertAction!) in
                let selectedLanguage = "de"
                self.englishButton.setImage(UIImage(named: "ico_off"), for: .normal)
                self.germanButton.setImage(UIImage(named: "ico_on"), for: .normal)
                LanguageManger.shared.setLanguage(language: selectedLanguage)
                GlobalData.logined = true
                self.gotoLoginScreen()
            }
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion:nil)
        }
        else {
            self.germanButton.setImage(UIImage(named: "ico_on"), for: .normal)
        }
    }
}
