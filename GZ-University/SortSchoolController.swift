//
//  DistanceController.swift
//  GZ-University
//
//  Created by Fidetro on 2019/1/16.
//  Copyright © 2019 karim. All rights reserved.
//

import UIKit

class SortSchoolController: UIViewController {
    var schools : [School]
    var didSelectSchool : ((_ school : School)->())?=nil
    lazy var tableView: UITableView = {
        var tableView = UITableView.init(frame: .zero, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    init(schools :[School]) {
        self.schools = schools
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        snpLayoutSubview()
        sortDistanceSchool()
    }
    
    func sortDistanceSchool() {
       schools = schools.sorted { $0.distance ?? 0 < $1.distance ?? 0 }
        tableView.reloadData()
    }
    
    func sortScoreSchool() {
        schools = schools.sorted { Int($0.varScore ?? "") ?? 0 < Int($1.varScore ?? "") ?? 0 }
        tableView.reloadData()
    }
    
}

// MARK: setup view
extension SortSchoolController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
    
    func snpLayoutSubview() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(300)
        }
    }
}

// MARK: view delegate
extension SortSchoolController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusable(withClass: SortSchoolTableViewCell.self)
        cell.textLabel?.text = schools[indexPath.row].schoolname
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectSchool = didSelectSchool {
            didSelectSchool(schools[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusable(withClass: SortSchoolHeaderView.self)
        headerView.clickAction = { (sender) in
            sender.selectRow = { [weak self](dataSource,detailSource) in
                
                if let source = dataSource[0] as? String {
                    switch source {
                        
                    case "distance":
                        self?.sortDistanceSchool()
                    case "varScore":
                        self?.sortScoreSchool()
                    default:
                        break
                    }
                    sender.resignFirstResponder()
                }
                
            }
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SortSchoolHeaderView.height
    }
    
}
