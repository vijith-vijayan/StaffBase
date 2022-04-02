//
//  EmployeeDetailsViewController.swift
//  StaffBase
//
//  Created by Vijith TV on 06/03/22.
//

import UIKit

class EmployeeDetailsViewController: UIViewController {

    //MARK: - IBOUTETS

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    //MARK: - PROPERTIES
    var employee: Employee?
    
    //MARK: - LIFE CYCLE METHODS

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configure(employee: employee)
    }
    
    //MARK: - CONFIGURE

    private func configure(employee: Employee?) {
        
        guard let employee = employee else {
            return
        }
        if let profileImage = employee.profileImage, let url = URL(string: profileImage) {
            profileImageView.setImage(from: url)
        }
        nameLabel.text = employee.name
        emailLabel.text = employee.email
        usernameLabel.text = employee.username
        phoneLabel.text = employee.phone
        websiteLabel.text = employee.website
        locationLabel.text = "\(employee.address?.city ?? ""),\(employee.address?.street ?? "")"
        companyLabel.text = "\(employee.company?.companyName ?? ""), \(employee.company?.catchPhrase ?? "")"
    }
    
    //MARK: - SETUP UI
    private func setupUI() {
        profileImageView.layer.cornerRadius = profileImageView.frame.size.width / 2
        profileImageView.layer.masksToBounds = true
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
