//
//  EmployeesViewController.swift
//  StaffBase
//
//  Created by Vijith TV on 05/03/22.
//

import UIKit

//MARK: - ENUM SECTION

/* USE IN CASE OF SHOWING STATIC SECTION */
enum Section {
    case main
}

class EmployeesViewController: UIViewController, Loadable {
    
    //MARK: - IBOUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //MARK: - PROPERTIES
    lazy var viewmodel: EmployeesViewModel = { EmployeesViewModel() }()
    
    /* TYPE ALIAS*/
    typealias EMPLOYEEDATASOURCE = UICollectionViewDiffableDataSource<Section, Employee>
    typealias EMPLOYEESNAPSHOT = NSDiffableDataSourceSnapshot<Section, Employee>
    
    /* DATASOURCE */
    private lazy var datasource = makeDatasource()
    
    /* SNAPSHOT */
    private var employeeSnapshot = EMPLOYEESNAPSHOT()

    //MARK: - LIFE CYCLE METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        configureViewmodel()
        configureTextField()
    }
    
    //MARK: - SETUP UI
    private func setupUI() {
        configureCollectionView()
    }
    
    //MARK: - PREPARE COLLECTIONVIEW
    private func configureCollectionView() {
        collectionView.register(EmployeeCell.nib, forCellWithReuseIdentifier: EmployeeCell.name)
        collectionView.dataSource = datasource
        collectionView.delegate = self
        collectionView.collectionViewLayout = employeeLayout()
    }
    
    //MARK: - CONFIGURE TEXTFIELD

    private func configureTextField() {
        searchTextField.addTarget(self, action: #selector(textDidChange(sender:)), for: .editingChanged)
    }
    
    //MARK: - TEXT DID CHANGE

    @objc func textDidChange(sender: UITextField) {
        
        guard let searchText = sender.text else { return }
        let employees = viewmodel.employees?.filter {
            $0.name?.contains(searchText) ?? false || $0.email?.contains(searchText) ?? false
        }
        if let emps = employees, !emps.isEmpty {
            applyEmployeeSnapshot(emps)
        } else {
            applyEmployeeSnapshot(viewmodel.employees ?? [])
        }
        
    }
    
    //MARK: -  CONFIGURE VIEW MODEL
    private func configureViewmodel() {
        showHUD()
        viewmodel.getEmployees { [weak self] in
            guard let weakself = self else { return }
            weakself.dismissHUD()
            weakself.viewmodel.getEmployeesFromDB { employees in
                weakself.applyEmployeeSnapshot(employees)
            }
        }
    }
    
    //MARK: - MAKE DATASOURCE
    private func makeDatasource() -> EMPLOYEEDATASOURCE {
        let datasource = EMPLOYEEDATASOURCE(collectionView: collectionView) { collectionView, indexPath, employee in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmployeeCell.name, for: indexPath) as? EmployeeCell else { fatalError("NO PROTOTYPE CELL FOUND") }
            cell.set(employee: employee)
            return cell
        }
      return datasource
    }
    
    //MARK: - APPLY SNAPSHOT
    private func applyEmployeeSnapshot(_ employees: [Employee]) {
        employeeSnapshot.deleteAllItems()
        employeeSnapshot.appendSections([.main])
        employeeSnapshot.appendItems(employees, toSection: .main)
        datasource.apply(employeeSnapshot, animatingDifferences: true, completion: nil)
    }
    
    //MARK: - EMPLOYEE LAYOUT
    func employeeLayout() -> UICollectionViewCompositionalLayout {
      let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.5),
            heightDimension: .fractionalHeight(1.0)
      )
      let item = NSCollectionLayoutItem(layoutSize: itemSize)
      let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.5)
      )
      let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
      let section = NSCollectionLayoutSection(group: group)
      let layout = UICollectionViewCompositionalLayout(section: section)
      return layout
    }
    
    //MARK: - PREPARE FOR SEGUE

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let vc = segue.destination as? EmployeeDetailsViewController else { return  }
        if let emp = sender as? Employee {
            vc.employee = emp
        }
    }
}

extension EmployeesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailSegue", sender: viewmodel.employees?[indexPath.row])
    }
    
}
