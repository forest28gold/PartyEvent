//
//  AddFriendViewController.swift
//  partymode
//
//  Created by AppsCreationTech on 3/25/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class AddFriendViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    
    @IBOutlet weak var tbl_CreatePartyCrowd: UITableView!
    @IBOutlet weak var emptyImage: UIImageView!
    
    var sectionsArray = [Sections]()
    var partypeopleArray = [PartyPeopleCellData]()
    var searchresult_partypeopleArray = [PartyPeopleCellData]()
    var temp_createdPartyCrowdItem: PartyCrowdCellData! = nil
    var shouldGoForward = false
    var shouldGoToEdit = false
    var sender = ""
    
    var searchButton : UIBarButtonItem!
    var searchBar:UISearchBar!
    
    var addedNewFriendsArray = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(CreatePartyCrowdViewController.methodOfSendDataToEditScreen(_:)), name:NSNotification.Name(rawValue: "notificationId_sendDataToMemberSelectAndEditScreen"), object: nil)
        self.title = NSLocalizedString("editpartycrowd", comment: "")
        tbl_CreatePartyCrowd.reloadData()
    }
    
    func methodOfSendDataToEditScreen(_ notification: Notification){
        //Take Action on Notification
        GlobalData.sharedInstance.removeAllSelectedPartyCrowdMemberFromArray()
        self.temp_createdPartyCrowdItem = notification.object as! PartyCrowdCellData
        
        self.tbl_CreatePartyCrowd.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyImage.image = UIImage(named: NSLocalizedString("imagename_empty_partypeople", comment: ""))
        
        searchBar = UISearchBar(frame: CGRect(x:0, y:0, width:self.view.frame.width - 60, height:20))
        searchBar.delegate = self
        searchBar.autocapitalizationType = .none
        
        self.title = NSLocalizedString("title_activity_create_crowd", comment: "")
        self.automaticallyAdjustsScrollViewInsets = false
        //navigationController?.navigationBar.barTintColor = Constants.tab_color_partycrowds
        setupRightItemButtonWithSearch()
        // Do any additional setup after loading the view.
        //GlobalData.sharedInstance.removeAllSelectedPartyCrowdMemberFromArray()
        self.partypeopleArray = GlobalData.sharedInstance.getPartyPeopleArray()
        let partypeoples = Sections(title: NSLocalizedString("partypeople", comment: ""), objects: self.partypeopleArray)
        self.sectionsArray.append(partypeoples)
    }
    
    func setupRightItemButtonWithSearch(){
        self.navigationItem.rightBarButtonItem  = nil
        let checkButton = UIBarButtonItem(image: UIImage(named: "ico-check"), style: .plain, target: self, action:#selector(self.checkButtonTapped))
        searchButton = UIBarButtonItem(image: UIImage(named: "ico-search"), style: .plain, target: self, action:#selector(self.searchButtonTapped))
        //self.navigationItem.rightBarButtonItem  = [searchButton,moreButton]
        self.navigationItem.setRightBarButtonItems([checkButton, searchButton], animated: true)
    }
    
    func checkButtonTapped(){
        self.cancelButtonTapped()
        let selectedPartyPeopleArray = GlobalData.selectedPartyCrowdMembersArray
        var phonenumberArray = [String]()
        for each in selectedPartyPeopleArray {
            
            var flag = true
            for e in phonenumberArray {
                if each.phonenumber == e {
                    flag = false
                }
            }
            if flag {
                phonenumberArray.append(each.phonenumber)
            }
            
        }
        
        self.temp_createdPartyCrowdItem.members.removeAll()
        
        for new_each_member in phonenumberArray {//from new array
            var isExist = false
            for original_each_member in self.temp_createdPartyCrowdItem.members {//from original array
                if original_each_member == new_each_member {
                    isExist = true
                    break
                }
            }
            if isExist == false {
                
                print("\(new_each_member) is new added contact, so inserting to DB now...")
                self.addedNewFriendsArray.append(new_each_member)
                //let isInserted = DBManager.getInstance().addContactData(original_each_member)
            }
        }
        
        let count = self.navigationController?.viewControllers.count
        let vc = self.navigationController?.viewControllers[count! - 2]// as! PartyCrowdEditViewController
        
        if String(describing: type(of: vc)) == "PartyCrowdEditViewController" {
            let viewController = vc as! PartyCrowdEditViewController
            viewController.createdPartyCrowdItem = self.temp_createdPartyCrowdItem
            _ = self.navigationController?.popViewController(animated: true)
        }
        else {
            let buf = DBManager.getInstance().getAllMemberItemsArray(self.temp_createdPartyCrowdItem.id)
            AddFriendsToCrowdAPICall().request(id: self.temp_createdPartyCrowdItem.id, title: self.temp_createdPartyCrowdItem.title, location: self.temp_createdPartyCrowdItem.location, partyTimeStamp: self.temp_createdPartyCrowdItem.partyTimeStamp, partyTime:self.temp_createdPartyCrowdItem.partyTime, invite_friends: self.temp_createdPartyCrowdItem.invite_friends, color: self.temp_createdPartyCrowdItem.color, members: self.addedNewFriendsArray, completionHandler: {(post) -> Void in
                let state = post.object(forKey: "state") as! String
                if state == "success" {
                    
                    print("Original party updated successfully")
                    //_ = DBManager.getInstance().addCrowdMembers(self.addedNewFriendsArray, crowdId: self.temp_createdPartyCrowdItem.id, status:Constants.CROWD_STATUS_PENDING)
                    
                    let isUpdated = DBManager.getInstance().updateCrowdData(self.temp_createdPartyCrowdItem)
                    if isUpdated {
                        _ = DBManager.getInstance().DeleteCrowdMembers(self.temp_createdPartyCrowdItem.id)
                        let myPhoneNr = UserDefaults.standard.string(forKey: "phone_nr")
                        _ = DBManager.getInstance().addCrowdMembers([myPhoneNr!], crowdId: self.temp_createdPartyCrowdItem.id, status:Constants.CROWD_STATUS_ACCEPTED)
                        
                        //_ = DBManager.getInstance().addCrowdMembers(phonenumberArray, crowdId: self.temp_createdPartyCrowdItem.id)
                        
                        
                        for e1 in self.addedNewFriendsArray {
                            var status = Constants.CROWD_STATUS_PENDING
                            
                            for e2 in buf {
                                if e1 != myPhoneNr && e1 == e2.phoneNumber {
                                    status = e2.status
                                    
                                    break
                                }
                            }
                            
                            if e1 != myPhoneNr {
                                _ = DBManager.getInstance().addCrowdMembers([e1], crowdId: self.temp_createdPartyCrowdItem.id, status: status)
                            }
                            
                        }
                        
                        //DBUtil.invokeAlertMethod("", strBody: "Record Updated successfully.", delegate: nil)
                        
                        
                    } else {
                        //DBUtil.invokeAlertMethod("", strBody: "Error in updating record.", delegate: nil)
                    }

                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_reloadMembersData"), object: nil)
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "notificationId_sendMembersArrayToEditScreen"), object: phonenumberArray)
                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
                
            })
        }
        
//        let count = self.navigationController?.viewControllers.count
//        let vc = self.navigationController?.viewControllers[count! - 2] as! PartyCrowdEditViewController
//        vc.createdPartyCrowdItem = self.temp_createdPartyCrowdItem
//        _ = self.navigationController?.popViewController(animated: true)
       
        
    }
    
    func searchButtonTapped(){
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        self.title = ""
        searchBar.setShowsCancelButton(true, animated: true)
        
        self.navigationItem.rightBarButtonItem  = nil
        let checkButton = UIBarButtonItem(image: UIImage(named: "ico-check"), style: .plain, target: self, action:#selector(self.checkButtonTapped))
        
        self.navigationItem.setRightBarButtonItems([checkButton], animated: false)
        self.searchBar.becomeFirstResponder()
        
    }
    
    func cancelButtonTapped(){
        self.title = NSLocalizedString("title_activity_create_crowd", comment: "")
        self.navigationItem.leftBarButtonItem = nil
        self.setupRightItemButtonWithSearch()
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadSearchedResult(searchText.lowercased())
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelButtonTapped()
    }
    
    func reloadSearchedResult(_ key:String){
        
        self.sectionsArray.removeAll()
        self.searchresult_partypeopleArray.removeAll()
        if key == ""{
            self.partypeopleArray = GlobalData.sharedInstance.getPartyPeopleArray()
            let partypeoples = Sections(title: NSLocalizedString("partypeople", comment: ""), objects: self.partypeopleArray)
            self.sectionsArray.append(partypeoples)
        }
        else {
            for each in self.partypeopleArray {
                if (each.name.lowercased().range(of: key) != nil) || (each.phonenumber.range(of: key) != nil) {
                    self.searchresult_partypeopleArray.append(each)
                }
            }
            let partypeoples = Sections(title: NSLocalizedString("partypeople", comment: ""), objects: self.searchresult_partypeopleArray)
            self.sectionsArray.append(partypeoples)
        }
        self.tbl_CreatePartyCrowd.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsArray[section].headings
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        emptyImage.isHidden = true
        return sectionsArray[section].partypeoples.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let eachData: PartyPeopleCellData = sectionsArray[indexPath.section].partypeoples[indexPath.row]
        
        switch self.tableView(tableView, titleForHeaderInSection: indexPath.section)! {
            
        case NSLocalizedString("partypeople", comment: ""):
            let cell = tbl_CreatePartyCrowd.dequeueReusableCell(withIdentifier: Constants.cellId_creatPartyCrowTableView, for: indexPath as IndexPath) as! CreatePartyCrowdTableViewCell
            cell.eachData = eachData
            cell.selfIndex = indexPath.row
            
            cell.phonenumberLabel.text = eachData.phonenumber
            cell.avatarImage.image = eachData.face_image
            cell.personName?.text = eachData.name
            
            if eachData.pmode == Constants.PARTYMODE_NA {//pending
                makeAvatarBoderBlack(avatarImageView: (cell.avatarImage))
            }
            if eachData.pmode == Constants.PARTYMODE_OFF {//off
                makeAvatarBoderRed(avatarImageView: (cell.avatarImage))
            }
            if eachData.pmode == Constants.PARTYMODE_ON {//on
                makeAvatarBoderGreen(avatarImageView: (cell.avatarImage))
                
            }
            
            
            var crowdData:PartyCrowdCellData?
            if temp_createdPartyCrowdItem != nil {
                crowdData = DBManager.getInstance().getCrowd(temp_createdPartyCrowdItem.id)
            }
            var hideSwichF = false
            
            if crowdData != nil {
                for e in crowdData!.members {
                    if eachData.phonenumber == e {
                        hideSwichF = true
                    }
                }
            }

            
            if self.temp_createdPartyCrowdItem != nil {
                for selectedMemberNr in self.temp_createdPartyCrowdItem.members {
                    if selectedMemberNr == eachData.phonenumber {
                        cell.setSwitchOn()
                        //cell.hiddenSwitch()
                    }
                }
            }
            
            var flag = false
            for e in GlobalData.selectedPartyCrowdMembersArray {
                if e.phonenumber == eachData.phonenumber {
                    //cell.setSwitchOn()
                    flag = true
                    break
                }
            }
            
            if flag {
                cell.setSwitchOn()
            }
            else {
                cell.setSwitchOff()
            }

            if hideSwichF {
                cell.hiddenSwitch()
            }
            return cell
            
        default:
            break
        }
        
        let cell = tbl_CreatePartyCrowd.dequeueReusableCell(withIdentifier: Constants.cellId_creatPartyCrowTableView, for: indexPath as IndexPath) as! CreatePartyCrowdTableViewCell
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
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
    
}
