//
//  EmployeeCell.swift
//  StaffBase
//
//  Created by Vijith TV on 05/03/22.
//

import UIKit

class EmployeeCell: UICollectionViewCell {

    //MARK: - IBOUTLTES

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    
    //MARK: - AWAKE FROM NIB

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupImageView()
    }
    
    //MARK: - SETUP IMAGE VIEW

    private func setupImageView() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
    }

    //MARK: - SET EMPLOYEE
    
    func set(employee: Employee) {
        nameLabel.text = employee.name
        companyNameLabel.text = employee.company?.companyName
        if let profileImage = employee.profileImage, let imageURL = URL(string: profileImage) {
            profileImageView.setImage(from: imageURL)
        } else {
            profileImageView.image = UIImage(named: "placeholder")
        }
    }
    
}
