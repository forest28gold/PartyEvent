//
//  FriendTabViewController.swift
//  partymode
//
//  Created by AppsCreationTech on 2/20/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit
import CRToast
import Contacts
import ContactsUI

class FriendTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , AcceptedPeopleTableViewCellDelegate{

    @IBOutlet weak var tbl_partypeople: UITableView!
    
    var selectedPartyCrowdItem: PartyCrowdCellData! = nil
    
    var sectionsArray = [Sections]()
    var crowdMemberItemsArray = [CrowdMemberItem]()
    var pendingPeopleArray = [PartyPeopleCellData]()
    var acceptedPeopleArray = [PartyPeopleCellData]()
    var regretPeopleArray = [PartyPeopleCellData]()
    
    @IBOutlet weak var reactivateButtonView: UIView!
    @IBOutlet weak var reactivateBttonLabel: UILabel!
    @IBOutlet weak var reactivateButtonViewHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var AcceptCancelView: UIView!
    @IBOutlet weak var AcceptButton: UIView!
    @IBOutlet weak var CancelButton: UIView!
    @IBOutlet weak var top_acceptButton: MKButton!
    @IBOutlet weak var top_cancelButton: MKButton!
    
    @IBOutlet weak var regretAlertView: UIView!
    @IBOutlet weak var alert_title: UILabel!
    @IBOutlet weak var alert_text: UILabel!
    @IBOutlet weak var alert_havePlanButton: UIButton!
    @IBOutlet weak var alert_StatyHomeButton: UIButton!
    @IBOutlet weak var alert_textfield: UITextField!
    @IBOutlet weak var alert_AcceptButton: UIButton!
    @IBOutlet weak var alert_RegretButton: UIButton!
    
    @IBOutlet weak var darkBgView: UIView!
    @IBOutlet weak var alert_dark_bg: UIView!
    
    @IBOutlet weak var declinedTopBannerView: UIView!
    @IBOutlet weak var declinedBanner_text_label: UILabel!
    @IBOutlet weak var declinedBanner_accept_button: MKButton!
    
    @IBOutlet weak var addPeopleButtonView: UIView!
    var loadContactsF = false
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(FriendTabViewController.methodOfReloadMembersData(_:)), name:NSNotification.Name(rawValue: "notificationId_reloadMembersData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfRefreshProfileImages(_:)), name:NSNotification.Name(rawValue: "notificationId_refreshContacts"), object: nil)
//        if self.loadContactsF {
//            DispatchQueue.main.async(execute: {
//                GlobalData.sharedInstance.loadContacts(sender: self)
//            })
//            
//            self.loadContactsF = false
//        }
        
    }
    
    func methodOfReloadMembersData(_ notification: Notification){
        loadInitialData()
    }
    
    func methodOfRefreshProfileImages(_ notification: Notification){
        loadInitialData()
        
    }
    
    func updateProfileImages(){
        let partypeopleArray = GlobalData.sharedInstance.getPartyPeopleArray()
        
        for eachPartyPeople in partypeopleArray {
            var i = 0
            for eachCrowdMembers in self.acceptedPeopleArray {
                if eachPartyPeople.phonenumber == eachCrowdMembers.phonenumber {
                    acceptedPeopleArray[i].face_image = eachPartyPeople.face_image
                    sectionsArray[0].partypeoples[i].face_image = eachPartyPeople.face_image
                    break
                }
                i = i + 1
            }
            
            var j = 0
            for eachCrowdMembers in self.pendingPeopleArray {
                if eachPartyPeople.phonenumber == eachCrowdMembers.phonenumber {
                    if sectionsArray.count > 1 {
                        sectionsArray[1].partypeoples[j].face_image = eachPartyPeople.face_image
                    }
                    break
                }
                j = j + 1
            }
            
            var k = 0
            for eachCrowdMembers in self.regretPeopleArray {
                if eachPartyPeople.phonenumber == eachCrowdMembers.phonenumber {
                    if sectionsArray.count > 2 {
                        sectionsArray[2].partypeoples[k].face_image = eachPartyPeople.face_image
                    }                    
                    break
                }
                k = k + 1
            }
        }
        self.tbl_partypeople.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeAddCrowdButtonCircleShadow()
        
        top_acceptButton.setTitle(NSLocalizedString("accept", comment: ""), for: UIControlState())
        top_cancelButton.setTitle(NSLocalizedString("decline", comment: ""), for: UIControlState())
        
        alert_title.text = NSLocalizedString("declinepartycrowd", comment: "")
        alert_text.text = NSLocalizedString("suredeclinepartycrowd", comment: "")
        alert_havePlanButton.setTitle(NSLocalizedString("engaged", comment: ""), for: UIControlState())
        alert_StatyHomeButton.setTitle(NSLocalizedString("stayhome", comment: ""), for: UIControlState())
        
        
        alert_AcceptButton.setTitle(NSLocalizedString("back", comment: "").uppercased(), for: UIControlState())
        alert_RegretButton.setTitle(NSLocalizedString("decline", comment: "").uppercased(), for: UIControlState())
        
        declinedBanner_text_label.text = NSLocalizedString("declinedalready", comment: "")
        declinedBanner_accept_button.setTitle(NSLocalizedString("accept", comment: ""), for: UIControlState())
        
        makeRegretAlertShadowStyle()
        
        reactivateBttonLabel.text = NSLocalizedString("reactivate_partycrowd", comment: "")
        makeReactiveButtonShadow()
        self.selectedPartyCrowdItem = GlobalData.sharedInstance.getSelectedPartyCrowdItem()
        if self.selectedPartyCrowdItem.isPastParty == true {
            showReactivateButtonView()
        }
        else {
            hiddenReactivateButtonView()
        }
        self.selectedPartyCrowdItem = GlobalData.sharedInstance.getSelectedPartyCrowdItem()
        loadInitialData()
        
        if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_PENDING {
            showAcceptCancelView()
        }
        else if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_DECLINED {
            self.showDeclinedBannerView()
        }
        else if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE {
            self.showDeclinedBannerView()
        }

        
        let isFromPartyHistory = UserDefaults.standard.string(forKey: "isFromPartyHistory")
        if isFromPartyHistory == "YES"{
            self.disableInterActions()
        }
        
    }
    
    func loadInitialData(){
        self.sectionsArray.removeAll()
        self.acceptedPeopleArray.removeAll()
        self.pendingPeopleArray.removeAll()
        self.regretPeopleArray.removeAll()
        self.crowdMemberItemsArray.removeAll()
        self.tbl_partypeople.reloadData()
        
        
        if self.selectedPartyCrowdItem.invite_friends == false {
            addPeopleButtonView.isHidden = true
            if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS {
                addPeopleButtonView.isHidden = false
            }
        }
        else {
            addPeopleButtonView.isHidden = false
            
        }
        
        self.crowdMemberItemsArray = DBManager.getInstance().getAllMemberItemsArray(self.selectedPartyCrowdItem.id)
        let partypeopleArray = GlobalData.sharedInstance.getPartyPeopleArray()
        
        
        for each in self.crowdMemberItemsArray {
            if each.status == Constants.CROWD_STATUS_ACCEPTED {
                var contactItem = DBManager.getInstance().getUser(each.phoneNumber)
                
                for e in partypeopleArray {
                    if each.phoneNumber == e.phonenumber {
//                        contactItem.pmode = e.pmode
//                        contactItem.name = e.name
                        contactItem = e
                        break
                    }
                }
                
                if contactItem.name == ""{
                    contactItem = PartyPeopleCellData(image: UIImage(named: "nav_profile_inactive")!, name_string: each.phoneNumber, phonenumber: each.phoneNumber, pmode: 0, img_off_lc: 0, img_on_lc: 0, img_pending_lc: 0, user_state: 0)
                }
                
                acceptedPeopleArray.append(contactItem)
            }
            
            if each.status == Constants.CROWD_STATUS_PENDING {
                var contactItem = DBManager.getInstance().getUser(each.phoneNumber)
                
                for e in partypeopleArray {
                    if each.phoneNumber == e.phonenumber {
//                        contactItem.name = e.name
//                        contactItem.pmode = e.pmode
                        contactItem = e
                        break
                    }
                }
                
                if contactItem.name == ""{
                    contactItem = PartyPeopleCellData(image: UIImage(named: "nav_profile_inactive")!, name_string: each.phoneNumber, phonenumber: each.phoneNumber, pmode: 0, img_off_lc: 0, img_on_lc: 0, img_pending_lc: 0, user_state: 0)
                }
                pendingPeopleArray.append(contactItem)
            }
            
            if each.status == Constants.CROWD_STATUS_DECLINED || each.status == Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE{
                var contactItem = DBManager.getInstance().getUser(each.phoneNumber)
                
                for e in partypeopleArray {
                    if each.phoneNumber == e.phonenumber {
//                        contactItem.name = e.name
//                        contactItem.pmode = e.pmode
                        contactItem = e
                        break
                    }
                }
                
                if contactItem.name == ""{
                    contactItem = PartyPeopleCellData(image: UIImage(named: "nav_profile_inactive")!, name_string: each.phoneNumber, phonenumber: each.phoneNumber, pmode: 0, img_off_lc: 0, img_on_lc: 0, img_pending_lc: 0, user_state: 0)
                }
                regretPeopleArray.append(contactItem)
            }
        }
        
        //if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_ACCEPTED {
            let emptyItem = PartyPeopleCellData(image: UIImage(named: "nav_profile_inactive")!, name_string: "", phonenumber: "", pmode: 0, img_off_lc: 0, img_on_lc: 0, img_pending_lc: 0, user_state: 0)
            regretPeopleArray.append(emptyItem)
        //}
        
        if self.acceptedPeopleArray.count > 0{
            let acceptPeoples = Sections(title: NSLocalizedString("acceptances", comment: ""), objects: self.acceptedPeopleArray)
            self.sectionsArray.append(acceptPeoples)
            
            let noanswerPeoples = Sections(title: NSLocalizedString("noanswer", comment: ""), objects: self.pendingPeopleArray)
            self.sectionsArray.append(noanswerPeoples)
            
            if self.regretPeopleArray.count > 0 {
                let regretPeoples = Sections(title: NSLocalizedString("declinations", comment: ""), objects: self.regretPeopleArray)
                self.sectionsArray.append(regretPeoples)
            }
            
        }
        self.tbl_partypeople.reloadData()
        
        updateProfileImages()
        
    }
    
    
    func selectCollectionItem(data : Any?)
    {
        let each = data as! PartyPeopleCellData
        
        let contacts = GlobalData.contactsArray
        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr") //
        
        var flag = true
        for e in contacts {
            if e.phonenumber == each.phonenumber || each.phonenumber == myPhoneNr{
                flag = false
                break
            }
        }
        
        if flag {
            
            let alertController = UIAlertController(title: NSLocalizedString("", comment:""), message: NSLocalizedString("add_to_contacts", comment:""), preferredStyle: .alert)//Add to Contacts
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert_No", comment:""), style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(cancelAction)
            
            
            let OKAction = UIAlertAction(title: NSLocalizedString("alert_yes", comment:""), style: .default) { (action:UIAlertAction!) in
                self.loadContactsF = true
                let store = CNContactStore()
                let contact = CNMutableContact()
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :each.phonenumber ))
                contact.phoneNumbers = [homePhone]
                let controller = CNContactViewController(forUnknownContact : contact)// .viewControllerForUnknownContact(contact)
                controller.contactStore = store
                //        controller.delegate = self as! CNContactViewControllerDelegate
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController!.pushViewController(controller, animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
    
    func showReactivateButtonView(){
        reactivateButtonView.isHidden = false
        reactivateButtonViewHeightConstraint.constant = 32
        
    }
    
    func hiddenReactivateButtonView(){
        reactivateButtonView.isHidden = true
        reactivateButtonViewHeightConstraint.constant = 0
    }
    
    func makeReactiveButtonShadow(){
        reactivateButtonView.layer.cornerRadius = 3
        reactivateButtonView.layer.shadowColor = UIColor.darkGray.cgColor
        reactivateButtonView.layer.shadowOpacity = 1
        reactivateButtonView.layer.shadowOffset = CGSize(width: 1.5, height: 1.5)
        reactivateButtonView.layer.borderWidth = 0
        reactivateButtonView.layer.shadowRadius = 2.0
        reactivateButtonView.layer.masksToBounds = false
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sectionsArray[section].headings
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //partyEmptyImage.isHidden = true
        if section == 0 {
            return 1
            
        }
//        else if section == 1 {
//            return sectionsArray[section].partypeoples.count + 1
//        }
        return sectionsArray[section].partypeoples.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.tableView(tableView, titleForHeaderInSection: indexPath.section)! == NSLocalizedString("acceptances", comment: ""){
           
            let height_ratio = UIScreen.main.bounds.height / 568
            var rowCount = 1
            if self.acceptedPeopleArray.count % 3 == 0 {
                rowCount = self.acceptedPeopleArray.count / 3
            }
            else{
                rowCount = self.acceptedPeopleArray.count / 3 + 1
            }
            
            return (120 * height_ratio) * CGFloat(rowCount)
            
        }
        else if self.tableView(tableView, titleForHeaderInSection: indexPath.section)! == NSLocalizedString("declinations", comment: ""){
            return 44
        }
        
        
        return 44
        
    }
    
    func validate(phoneNumber: String) -> Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = phoneNumber.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  phoneNumber == filtered
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachData: PartyPeopleCellData = sectionsArray[indexPath.section].partypeoples[indexPath.row]
        
        switch self.tableView(tableView, titleForHeaderInSection: indexPath.section)! {
            
        case NSLocalizedString("acceptances", comment: ""):
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellId_AcceptedPeopleTableView, for: indexPath) as! AcceptedPeopleTableViewCell
            cell.acceptedPeopleArray = self.acceptedPeopleArray
            cell.sortArrayForMeFirst()
            cell.collectionView.reloadData()
            cell.delegate = self
            
            return cell
            
        case NSLocalizedString("noanswer", comment: ""):
            let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_partypeopleTableView, for: indexPath as IndexPath) as! PartyPeopleTableViewCell
            
            cell.phonenumberLabel.text = eachData.phonenumber
            cell.avatarImage.image = eachData.face_image
            
            let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
            if eachData.phonenumber == myPhoneNr {
                cell.personName?.text = NSLocalizedString("me", comment: "")
                _ = UserDefaults.standard.string(forKey: "phone_nr") //let myPhoneNr
                let partymode = UserDefaults.standard.integer(forKey: Constants.SP_PARTYMODE)
                if partymode == Constants.PARTYMODE_NA {//pending
                    if UserDefaults.standard.string(forKey: "partymodePendingImageSaved") == "YES" {
                        cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodePending.jpg")
                    }
                    makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                }
                if partymode == Constants.PARTYMODE_OFF {//off
                    if UserDefaults.standard.string(forKey: "partymodeOFFImageSaved") == "YES" {
                        cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeOFF.jpg")
                        makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                    }
                }
                if partymode == Constants.PARTYMODE_ON {//on
                    if UserDefaults.standard.string(forKey: "partymodeONImageSaved") == "YES" {
                        cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeON.jpg")
                    }
                    makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                }
            }
            else {
                
                cell.personName?.text = eachData.name
                let str = UserDefaults.standard.string(forKey: eachData.name)
                if str != nil && str != "" {
                    cell.personName?.text = str
                    cell.personName?.font = UIFont.italicSystemFont(ofSize:16.0)
                }
                else if validate(phoneNumber: eachData.name) {
                    cell.personName?.font = UIFont.italicSystemFont(ofSize:16.0)
                }
                else {
                    cell.personName?.font = UIFont.systemFont(ofSize:16.0)
                }
                
                if eachData.pmode == Constants.PARTYMODE_NA {//pending
                    makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                    cell.partyfyButton.isHidden = false
                    cell.partyfyIcon.isHidden = false
                    //cell.disablePartify()
                }
                if eachData.pmode == Constants.PARTYMODE_OFF {//off
                    makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                    cell.partyfyButton.isHidden = true
                    cell.partyfyIcon.isHidden = true
                    //cell.disablePartify()
                }
                if eachData.pmode == Constants.PARTYMODE_ON {//on
                    makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                    cell.partyfyButton.isHidden = true
                    cell.partyfyIcon.isHidden = true
                    //cell.enblePartify()
                }
            }
            
            
            let partified_time = DBManager.getInstance().getPartifyInfo(eachData.phonenumber)
            
            let current_time = Int(NSDate().timeIntervalSince1970)
            if partified_time == 0 || (current_time - partified_time) > Constants.FREQUENCY_PARTIFY {
                cell.disablePartify()
            }
            else {
                cell.enblePartify()
            }
            
            //            if partified_time == 0 {
            //                cell.disablePartify()
            //            }
            //            else {
            //                cell.enblePartify()
            //            }
            
            cell.partyfyButton.tag = indexPath.row
            cell.partyfyButton.addTarget(self, action:  #selector(self.partifyClicked(_:)),for: .touchUpInside)
            
            return cell
            
        case NSLocalizedString("declinations", comment: ""):
            if self.selectedPartyCrowdItem.status == Constants.CROWD_STATUS_ACCEPTED {
                
                if indexPath.row == self.regretPeopleArray.count - 1 {
                    let declineButtonCell = tbl_partypeople.dequeueReusableCell(withIdentifier: "declineButton_cellId", for: indexPath as IndexPath) as! DeclineButtonTableViewCell
                    
                    declineButtonCell.regretButton.tag = 999
                    declineButtonCell.regretButton.addTarget(self, action:  #selector(self.regretCellButtonClicked(_:)),for: .touchUpInside)
                    
                    declineButtonCell.currentPartyCrowdItem = self.selectedPartyCrowdItem
                    return declineButtonCell
                }
                    
                else {
                    
                    let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_partypeopleTableView, for: indexPath as IndexPath) as! PartyPeopleTableViewCell
                    
                    var reason = ""
                    
                    for i in 0 ..< self.crowdMemberItemsArray.count {
                        if self.crowdMemberItemsArray[i].phoneNumber == eachData.phonenumber {
                            reason = self.crowdMemberItemsArray[i].msg
                            break
                        }
                    }
                    
                    print(reason)
                    
                    cell.phonenumberLabel.text = eachData.phonenumber
                    cell.avatarImage.image = eachData.face_image
                    
                    let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
                    if eachData.phonenumber == myPhoneNr {
                        cell.personName?.text = NSLocalizedString("me", comment: "")
                        _ = UserDefaults.standard.string(forKey: "phone_nr") //let myPhoneNr
                        let partymode = UserDefaults.standard.integer(forKey: Constants.SP_PARTYMODE)
                        if partymode == Constants.PARTYMODE_NA {//pending
                            if UserDefaults.standard.string(forKey: "partymodePendingImageSaved") == "YES" {
                                cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodePending.jpg")
                            }
                            makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                        }
                        if partymode == Constants.PARTYMODE_OFF {//off
                            if UserDefaults.standard.string(forKey: "partymodeOFFImageSaved") == "YES" {
                                cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeOFF.jpg")
                                makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                            }
                        }
                        if partymode == Constants.PARTYMODE_ON {//on
                            if UserDefaults.standard.string(forKey: "partymodeONImageSaved") == "YES" {
                                cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeON.jpg")
                            }
                            makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                        }
                    }
                    else {
                        cell.personName?.text = eachData.name
                        let str = UserDefaults.standard.string(forKey: eachData.name)
                        if str != nil && str != "" {
                            cell.personName?.text = str
                            cell.personName?.font = UIFont.italicSystemFont(ofSize:16.0)
                        }
                        else if validate(phoneNumber: eachData.name) {
                            cell.personName?.font = UIFont.italicSystemFont(ofSize:16.0)
                        }
                        else {
                            cell.personName?.font = UIFont.systemFont(ofSize:16.0)
                        }
                        
                        if eachData.pmode == Constants.PARTYMODE_NA {//pending
                            makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                            cell.partyfyButton.isHidden = false
                            cell.partyfyIcon.isHidden = false
                            //cell.disablePartify()
                        }
                        if eachData.pmode == Constants.PARTYMODE_OFF {//off
                            makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                            cell.partyfyButton.isHidden = true
                            cell.partyfyIcon.isHidden = true
                            //cell.disablePartify()
                        }
                        if eachData.pmode == Constants.PARTYMODE_ON {//on
                            makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                            cell.partyfyButton.isHidden = true
                            cell.partyfyIcon.isHidden = true
                            //cell.enblePartify()
                        }
                    }
                    
                    if reason != "" {
                        cell.phonenumberLabel.isHidden = false
                        cell.phonenumberLabel.text = NSLocalizedString(reason, comment: "")
                        cell.phonenumberLabel.font = UIFont.italicSystemFont(ofSize:10.0)
                    }
                    
                    let partified_time = DBManager.getInstance().getPartifyInfo(eachData.phonenumber)
                    
                    let current_time = Int(NSDate().timeIntervalSince1970)
                    if partified_time == 0 || (current_time - partified_time) > Constants.FREQUENCY_PARTIFY {
                        cell.disablePartify()
                    }
                    else {
                        cell.enblePartify()
                    }
                    
                    //            if partified_time == 0 {
                    //                cell.disablePartify()
                    //            }
                    //            else {
                    //                cell.enblePartify()
                    //            }
                    
                    cell.partyfyButton.tag = indexPath.row
                    cell.partyfyButton.addTarget(self, action:  #selector(self.partifyClicked(_:)),for: .touchUpInside)
                    
                    return cell
                    
//                    let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_contactTableView, for: indexPath as IndexPath) as! ContactTableViewCell
//                    
//                    cell.avatarImage.image = eachData.face_image
//                    cell.personName?.text = eachData.name
//                    
//                    let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
//                    if eachData.phonenumber == myPhoneNr {
//                        cell.personName?.text = NSLocalizedString("me", comment: "")
//                        if eachData.pmode == Constants.PARTYMODE_NA {//pending
//                            cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodePending.jpg")
//                        }
//                        if eachData.pmode == Constants.PARTYMODE_OFF {//off
//                            if UserDefaults.standard.string(forKey: "partymodeOFFImageSaved") == "YES" {
//                                cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeOFF.jpg")
//                            }
//                        }
//                        if eachData.pmode == Constants.PARTYMODE_ON {//on
//                            cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeON.jpg")
//                        }
//                    }
//                    else {
//                        cell.personName?.text = eachData.name
//                    }
//                    
////                    cell.inviteButton.tag = indexPath.row
//                    
////                    let contactItem = DBManager.getInstance().getUser(eachData.phonenumber)
////                    if contactItem.name != "" {
////                        cell.inviteButton.isHidden = false
////                    }
//                    cell.inviteButton.isHidden = true
//                    
//                    if eachData.pmode == Constants.PARTYMODE_NA {//pending
//                        makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
//                        
//                    }
//                    if eachData.pmode == Constants.PARTYMODE_OFF {//off
//                        makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
//                        
//                    }
//                    if eachData.pmode == Constants.PARTYMODE_ON {//on
//                        makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
//                        
//                    }
//                    
//                    return cell
                }
            }
            else {
                
                if eachData.phonenumber == "" {
                    let declineButtonCell = tbl_partypeople.dequeueReusableCell(withIdentifier: "declineButton_cellId", for: indexPath as IndexPath) as! DeclineButtonTableViewCell
                    
                    declineButtonCell.regretButton.tag = 999
                    declineButtonCell.regretButton.addTarget(self, action:  #selector(self.regretCellButtonClicked(_:)),for: .touchUpInside)
                    
                    declineButtonCell.currentPartyCrowdItem = self.selectedPartyCrowdItem
                    return declineButtonCell
                }
                
                let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_partypeopleTableView, for: indexPath as IndexPath) as! PartyPeopleTableViewCell
                
                var reason = ""
                
                for i in 0 ..< self.crowdMemberItemsArray.count {
                    if self.crowdMemberItemsArray[i].phoneNumber == eachData.phonenumber {
                        reason = self.crowdMemberItemsArray[i].msg
//                        if msg.contains(NSLocalizedString("leftchat", comment: "")) && msg.contains(":") {
//                            let bufAry = msg.components(separatedBy: ":")
//                            if bufAry.count > 1 {
//                                reason = bufAry[1]
//                            }
//                        }
                        break
                    }
                }
                
                print(reason)
                
                cell.phonenumberLabel.text = eachData.phonenumber
                cell.avatarImage.image = eachData.face_image
                
                let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
                if eachData.phonenumber == myPhoneNr {
                    cell.personName?.text = NSLocalizedString("me", comment: "")
                    _ = UserDefaults.standard.string(forKey: "phone_nr") //let myPhoneNr
                    let partymode = UserDefaults.standard.integer(forKey: Constants.SP_PARTYMODE)
                    if partymode == Constants.PARTYMODE_NA {//pending
                        if UserDefaults.standard.string(forKey: "partymodePendingImageSaved") == "YES" {
                            cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodePending.jpg")
                        }
                        makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                    }
                    if partymode == Constants.PARTYMODE_OFF {//off
                        if UserDefaults.standard.string(forKey: "partymodeOFFImageSaved") == "YES" {
                            cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeOFF.jpg")
                            makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                        }
                    }
                    if partymode == Constants.PARTYMODE_ON {//on
                        if UserDefaults.standard.string(forKey: "partymodeONImageSaved") == "YES" {
                            cell.avatarImage.image = SaveLoadImageToLocalClass().getImage(imageNameWithExt: "partymodeON.jpg")
                        }
                        makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                    }
                }
                else {
                    cell.personName?.text = eachData.name
                    let str = UserDefaults.standard.string(forKey: eachData.name)
                    if str != nil && str != "" {
                        cell.personName?.text = str
                    }
                    if eachData.pmode == Constants.PARTYMODE_NA {//pending
                        makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
                        cell.partyfyButton.isHidden = false
                        cell.partyfyIcon.isHidden = false
                        //cell.disablePartify()
                    }
                    if eachData.pmode == Constants.PARTYMODE_OFF {//off
                        makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
                        cell.partyfyButton.isHidden = true
                        cell.partyfyIcon.isHidden = true
                        //cell.disablePartify()
                    }
                    if eachData.pmode == Constants.PARTYMODE_ON {//on
                        makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                        cell.partyfyButton.isHidden = true
                        cell.partyfyIcon.isHidden = true
                        //cell.enblePartify()
                    }
                }
                
                if reason != "" {
                    cell.phonenumberLabel.isHidden = false
                    cell.phonenumberLabel.text = NSLocalizedString(reason, comment: "")
                    cell.phonenumberLabel.font = UIFont.italicSystemFont(ofSize:10.0)
                }
                
                let partified_time = DBManager.getInstance().getPartifyInfo(eachData.phonenumber)
                
                let current_time = Int(NSDate().timeIntervalSince1970)
                if partified_time == 0 || (current_time - partified_time) > Constants.FREQUENCY_PARTIFY {
                    cell.disablePartify()
                }
                else {
                    cell.enblePartify()
                }
                
                //            if partified_time == 0 {
                //                cell.disablePartify()
                //            }
                //            else {
                //                cell.enblePartify()
                //            }
                
                cell.partyfyButton.tag = indexPath.row
                cell.partyfyButton.addTarget(self, action:  #selector(self.partifyClicked(_:)),for: .touchUpInside)
                
                return cell
//                let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_contactTableView, for: indexPath as IndexPath) as! ContactTableViewCell
////                let msg = self.crowdMemberItemsArray[indexPath.row].msg
////                print(indexPath.row)
////                print(msg)
//                
//                var reason = ""
//                
//                for i in 0 ..< self.crowdMemberItemsArray.count {
//                    if self.crowdMemberItemsArray[i].phoneNumber == eachData.phonenumber {
//                        let msg = self.crowdMemberItemsArray[i].msg
//                        if msg.contains(NSLocalizedString("leftchat", comment: "")) && msg.contains(":") {
//                            let bufAry = msg.components(separatedBy: ":")
//                            if bufAry.count > 1 {
//                                reason = bufAry[1]
//                            }
//                        }
//                        break
//                    }
//                }
//                
//                print(reason)
//                
//                cell.avatarImage.image = eachData.face_image
//                cell.personName?.text = eachData.name
//                cell.phonenumberLabel.text = eachData.phonenumber
//                cell.inviteButton.tag = indexPath.row
//                
//                if reason != "" {
//                    cell.reasonLabel.isHidden = false
//                    cell.reasonLabel.text = reason
//                }
//                else {
//                    cell.reasonLabel.isHidden = true
//                }
//                
//                let contactItem = DBManager.getInstance().getUser(eachData.phonenumber)
//                if contactItem.name != "" {
//                    cell.inviteButton.isHidden = false
//                }
//                
//                
//                if eachData.pmode == Constants.PARTYMODE_NA {//pending
//                    makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
//                    
//                }
//                if eachData.pmode == Constants.PARTYMODE_OFF {//off
//                    makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
//                    
//                }
//                if eachData.pmode == Constants.PARTYMODE_ON {//on
//                    makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
//                    
//                }
//                
//                return cell
            }
            
        
        default:
            break
        }
        
        let cell = tbl_partypeople.dequeueReusableCell(withIdentifier: Constants.cellId_partypeopleTableView, for: indexPath as IndexPath) as! PartyPeopleTableViewCell
        return cell
        
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        let eachData: PartyPeopleCellData = sectionsArray[indexPath.section].partypeoples[indexPath.row]
        print(eachData)
        
        if eachData.phonenumber == "" {
            return
        }
        
        let contacts = GlobalData.contactsArray
        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr") //
        
        var flag = true
        for e in contacts {
            if e.phonenumber == eachData.phonenumber || eachData.phonenumber == myPhoneNr{
                flag = false
                break
            }
        }
        
        if flag {
            let alertController = UIAlertController(title: NSLocalizedString("", comment:""), message: NSLocalizedString("add_to_contacts", comment:""), preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: NSLocalizedString("alert_No", comment:""), style: .cancel) { (action:UIAlertAction!) in
                
            }
            alertController.addAction(cancelAction)
            
            
            let OKAction = UIAlertAction(title: NSLocalizedString("alert_yes", comment:""), style: .default) { (action:UIAlertAction!) in
                self.loadContactsF = true
                let store = CNContactStore()
                let contact = CNMutableContact()
                let homePhone = CNLabeledValue(label: CNLabelHome, value: CNPhoneNumber(stringValue :eachData.phonenumber ))
                contact.phoneNumbers = [homePhone]
                let controller = CNContactViewController(forUnknownContact : contact)// .viewControllerForUnknownContact(contact)
                controller.contactStore = store
                //        controller.delegate = self as! CNContactViewControllerDelegate
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.navigationController!.pushViewController(controller, animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
            
        }


    }

    func makeAvatarBoderGreen(avatarImageView: UIImageView){
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.borderColor = Constants.avartar_color_green.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.masksToBounds = true
    }
    
    func makeAvatarBoderBlack(avatarImageView: UIImageView){
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.borderColor = Constants.avartar_color_black.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.masksToBounds = true
    }
    
    func makeAvatarBoderRed(avatarImageView: UIImageView){
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
        avatarImageView.layer.borderColor = Constants.avartar_color_red.cgColor
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.masksToBounds = true
    }
    
    @objc func regretCellButtonClicked(_ sender:UIButton) {
        print(sender.tag)
        self.showRegretAlert()
        //self.alert_RegretButtonPressed(nil)
        
    }
    
    @objc func partifyClicked(_ sender:UIButton) {
        print(sender.tag)
        
        var selectedItem: PartyPeopleCellData?
        
        if sectionsArray[1].partypeoples.count > sender.tag {
            selectedItem = sectionsArray[1].partypeoples[sender.tag]
        }
        else {
            selectedItem = sectionsArray[2].partypeoples[sender.tag]
        }
        
        if selectedItem == nil {
            return
        }
        
        PartifyContactAPICall().request(self, phone_nrToPartify: selectedItem!.phonenumber, completionHandler: {(post) -> Void in
            if post == "failed" {
                
            }
            else {
                self.showToast(selectedItem!.name + " " + NSLocalizedString("partify_success", comment: ""))
            }
        })
    }
    
    @IBAction func reactivatePartyCrowdButtonPressed(_ sender: Any) {
        UserDefaults.standard.set("true", forKey: "shouldBeReactivate")
        NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_sendDataToMemberSelectAndEditScreen"), object: self.selectedPartyCrowdItem)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func showToast(_ string:String){
        let options:[NSObject:AnyObject]  = [
            kCRToastNotificationPresentationTypeKey as NSObject : 1 as AnyObject,
            kCRToastTextKey as NSObject : string as AnyObject,
            kCRToastBackgroundColorKey as NSObject : UIColor.orange,
            kCRToastTextColorKey as NSObject: UIColor.white,
            kCRToastFontKey as NSObject: UIFont(name:"HelveticaNeue-Bold", size: 15)!,
            kCRToastTextMaxNumberOfLinesKey as NSObject: 2 as AnyObject,
            kCRToastTimeIntervalKey as NSObject: NSNumber(value: 2.5) as AnyObject,
            kCRToastUnderStatusBarKey as NSObject : NSNumber(value: true),
            kCRToastImageAlignmentKey as NSObject : NSNumber(value: NSTextAlignment.left.rawValue) as AnyObject,
            kCRToastTextAlignmentKey as NSObject : NSNumber(value: NSTextAlignment.left.rawValue) as AnyObject,
            kCRToastImageKey as NSObject : UIImage(named: "ico_partyfy05")!,
            kCRToastNotificationTypeKey as NSObject : NSNumber(value: CRToastType.navigationBar.rawValue) as AnyObject,
            kCRToastAnimationInTypeKey as NSObject : NSNumber(value: CRToastAnimationType.spring.rawValue) as AnyObject,
            kCRToastAnimationOutTypeKey as NSObject : NSNumber(value: CRToastAnimationType.spring.rawValue) as AnyObject,
            kCRToastAnimationInDirectionKey as NSObject : NSNumber(value:CRToastAnimationDirection.top.rawValue) as AnyObject,
            kCRToastAnimationOutDirectionKey as NSObject : CRToastAnimationDirection.top.rawValue as AnyObject,
            //kCRToastNotificationPreferredPaddingKey as NSObject : NSNumber(value: Int(self.view.bounds.width/12)) as AnyObject
        ]
        
        CRToastManager.showNotification(options: options, completionBlock: { () -> Void in
            print("done!")
        })
    }
    
    func makeRegretAlertShadowStyle(){
        regretAlertView.layer.cornerRadius = 6
        regretAlertView.layer.shadowColor = UIColor.black.cgColor
        regretAlertView.layer.shadowOpacity = 1
        regretAlertView.layer.shadowOffset = CGSize(width: 3, height: 3)
        regretAlertView.layer.borderWidth = 0
    }
    
    func showAcceptCancelView() {
        darkBgView.isHidden = false
        AcceptCancelView.isHidden = false
    }
    
    @IBAction func topAcceptButtonPressed(_ sender: Any) {
        var members = [String]()
        for each in self.crowdMemberItemsArray {
            members.append(each.phoneNumber)
        }
        AcceptRegretCrowdAPICall().request(self, id: self.selectedPartyCrowdItem.id, status: Constants.CROWD_STATUS_ACCEPTED, msg: "", members:members, completionHandler: {(post) -> Void in
            if post == "success" {
                if self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_ACCEPTED) //let isUpdated
                    self.hideDeclinedBannerView()
                    self.acceptedProcessInDB()
                }
                else {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS) //let isUpdated
                    //self.declinedProcessInDB(reason: regret_reason_str!)
                    self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS
                    self.loadInitialData()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadBufTab3Screen"), object: nil)
            }
            else {
                
            }
        })
    }
    
    @IBAction func topCancelButtonPressed(_ sender: Any) {
        self.showRegretAlert()
    }
    
    @IBAction func alert_havePlanButtonPressed(_ sender: Any) {
        var members = [String]()
        for each in self.crowdMemberItemsArray {
            members.append(each.phoneNumber)
        }
        print(members)
        let regret_reason_str = (sender as AnyObject).title(for: .normal)
        AcceptRegretCrowdAPICall().request(self, id: self.selectedPartyCrowdItem.id, status: Constants.CROWD_STATUS_DECLINED, msg: regret_reason_str!, members:members, completionHandler: {(post) -> Void in
            if post == "success" {
                self.showDeclinedBannerView()
                if self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DECLINED) //let isUpdated
                    self.declinedProcessInDB(reason: regret_reason_str!)
                }
                else {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE) //let isUpdated
                    //self.declinedProcessInDB(reason: regret_reason_str!)
                    self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE
                    self.loadInitialData()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadBufTab3Screen"), object: nil)
                
            }
            else {
                
            }
        })
    }
    
    @IBAction func alert_stayHomeButtonPressed(_ sender: Any) {
        var members = [String]()
        for each in self.crowdMemberItemsArray {
            members.append(each.phoneNumber)
        }
        print(members)
        let regret_reason_str = (sender as AnyObject).title(for: .normal)
        AcceptRegretCrowdAPICall().request(self, id: self.selectedPartyCrowdItem.id, status: Constants.CROWD_STATUS_DECLINED, msg: regret_reason_str!, members:members, completionHandler: {(post) -> Void in
            if post == "success" {
                self.showDeclinedBannerView()
                if self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DECLINED) //let isUpdated
                    self.declinedProcessInDB(reason: regret_reason_str!)
                }
                else {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE) //let isUpdated
                    //self.declinedProcessInDB(reason: regret_reason_str!)
                    self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE
                    self.loadInitialData()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadBufTab3Screen"), object: nil)
                
            }
            else {
                
            }
        })
    }
    
    @IBAction func alert_AcceptButtonPressed(_ sender: Any) {
        self.hiddenRegretAlert()
    }
    
    @IBAction func alert_RegretButtonPressed(_ sender: Any?) {
        var members = [String]()
        for each in self.crowdMemberItemsArray {
            members.append(each.phoneNumber)
        }
        let regret_reason_str = self.alert_textfield.text
        AcceptRegretCrowdAPICall().request(self, id: self.selectedPartyCrowdItem.id, status: Constants.CROWD_STATUS_DECLINED, msg: regret_reason_str!, members:members, completionHandler: {(post) -> Void in
            if post == "success" {
                
                self.showDeclinedBannerView()
                if self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DECLINED) //let isUpdated
                    self.declinedProcessInDB(reason: regret_reason_str!)
                }
                else {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE) //let isUpdated
                    self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE
                    //self.declinedProcessInDB(reason: regret_reason_str!)
                    self.loadInitialData()
                }
                NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadBufTab3Screen"), object: nil)
            }
            else {
                
            }
        })
        
    }
    
    func showDeclinedBannerView(){
        self.alert_dark_bg.isHidden = true
        self.hiddenRegretAlert()
        self.darkBgView.isHidden = false
        self.AcceptCancelView.isHidden = true
        self.declinedTopBannerView.isHidden = false
    }
    
    func hideDeclinedBannerView(){
        self.alert_dark_bg.isHidden = true
        self.hiddenRegretAlert()
        self.darkBgView.isHidden = true
        self.AcceptCancelView.isHidden = true
        self.declinedTopBannerView.isHidden = true
    }
    
    func showRegretAlert(){
        UIView.animate(withDuration: 0.5, animations: {
            self.regretAlertView.alpha = 1
            self.alert_dark_bg.alpha = 0.5
        })
    }
    
    func hiddenRegretAlert(){
        UIView.animate(withDuration: 0.5, animations: {
            self.alert_dark_bg.alpha = 0
            self.regretAlertView.alpha = 0
            
            
        })
    }
    
    @IBAction func declinedBanner_accept_pressed(_ sender: Any) {
        var members = [String]()
        for each in self.crowdMemberItemsArray {
            members.append(each.phoneNumber)
        }
        AcceptRegretCrowdAPICall().request(self, id: self.selectedPartyCrowdItem.id, status: Constants.CROWD_STATUS_ACCEPTED, msg: "", members:members, completionHandler: {(post) -> Void in
            if post == "success" {
                self.hideDeclinedBannerView()
                if self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_DECLINE && self.selectedPartyCrowdItem.status != Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS{
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_ACCEPTED) //let isUpdated
                    self.acceptedProcessInDB()
                }
                else {
                    _ = DBManager.getInstance().updateCrowdData(self.selectedPartyCrowdItem, crowd_status: Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS) //let isUpdated
                    self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DO_NO_CHANGE_STATUS
                    self.loadInitialData()
                }                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadBufTab3Screen"), object: nil)
            }
            else {
                
            }
        })
    }
    
    func declinedProcessInDB(reason:String){
        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
        _ = DBManager.getInstance().updateCrowdMemberData(self.selectedPartyCrowdItem.id, phoneNr: myPhoneNr!, crowd_status: Constants.CROWD_STATUS_DECLINED, msg: reason) //let isUpdated
        
        self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_DECLINED
        self.loadInitialData()
    }
    
    func acceptedProcessInDB(){
        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
        _ = DBManager.getInstance().updateCrowdMemberData(self.selectedPartyCrowdItem.id, phoneNr: myPhoneNr!, crowd_status: Constants.CROWD_STATUS_ACCEPTED, msg: "") //let isUpdated
        self.selectedPartyCrowdItem.status = Constants.CROWD_STATUS_ACCEPTED
        self.loadInitialData()

    }
    
    func makeAddCrowdButtonCircleShadow(){
        addPeopleButtonView.layer.cornerRadius = addPeopleButtonView.bounds.width / 2
        addPeopleButtonView.layer.shadowColor = UIColor.gray.cgColor
        addPeopleButtonView.layer.shadowOpacity = 1
        addPeopleButtonView.layer.shadowOffset = CGSize(width: 2, height: 2)
        addPeopleButtonView.layer.borderWidth = 0
    }
    
    @IBAction func AddFriend_Pressed(_ sender: Any) {
//        GlobalData.selectedPartyCrowdMembersArray = GlobalData.sharedInstance.getPartyPeopleArray()
        GlobalData.selectedPartyCrowdMembersArray.removeAll()
        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
        for each in self.crowdMemberItemsArray {
            if each.phoneNumber != myPhoneNr {
                var contactItem = DBManager.getInstance().getUser(each.phoneNumber)
                if contactItem.name == ""{
                    contactItem = PartyPeopleCellData(image: UIImage(named: "nav_profile_inactive")!, name_string: each.phoneNumber, phonenumber: each.phoneNumber, pmode: 0, img_off_lc: 0, img_on_lc: 0, img_pending_lc: 0, user_state: 0)
                }
                
                GlobalData.selectedPartyCrowdMembersArray.append(contactItem)
            }
        }

        //NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_sendDataToMemberSelectAndEditScreen"), object: self.selectedPartyCrowdItem)
        let viewController =  self.storyboard?.instantiateViewController(withIdentifier: "AddFriendViewController") as! AddFriendViewController
        viewController.temp_createdPartyCrowdItem = self.selectedPartyCrowdItem
        GlobalData.sharedInstance.setSelectedPartyCrowdItem(self.selectedPartyCrowdItem)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func disableInterActions(){
        self.addPeopleButtonView.isHidden = true
        self.declinedBanner_accept_button.isHidden = true
        self.AcceptCancelView.isHidden = true
    }
}


//GetUserNameAPICall().request(self, contacts: ["+8615141585683"], completionHandler: {(post) -> Void in
//    print(post)
//})
