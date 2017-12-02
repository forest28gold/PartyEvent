//
//  ContactTableViewCell.swift
//  partymode
//
//  Created by AppsCreationTech on 2/2/17.
//  Copyright © 2017 AppsCreationTech. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var inviteButton: UIButton!
    
    @IBOutlet weak var phonenumberLabel: UILabel!
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        avatarImage.contentMode = UIViewContentMode.scaleAspectFill
        inviteButton.setTitle(NSLocalizedString("invite", comment: "").uppercased(), for: UIControlState())
        
        inviteButton.layer.borderWidth = 0.8
        inviteButton.layer.cornerRadius = 5
        inviteButton.layer.borderColor = UIColor.darkText.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }    
    
    func showInviteAndHiddenPartyfyButtonsAndIcon(){
        
        inviteButton.isHidden = false
    }
    
    
}
