//
//  ClaimDetailsTableViewController.swift
//  Redwoods Insurance Project
//
//  Created by Kevin Poorman on 11/26/18.
//  Copyright © 2018 Salesforce. All rights reserved.
//

import UIKit
import SalesforceSDKCore

class ClaimDetailsTableViewController: UITableViewController {

	var claimId: String?
	var dataSource: ObjectLayoutDataSource!
	let reuseIdentifier = "CaseDetailPrototype"

	override func viewDidLoad() {
		super.viewDidLoad()
		if let caseId = claimId {
			self.dataSource = ObjectLayoutDataSource(
				objectType: "Case",
				objectId: caseId,
				cellReuseIdentifier: self.reuseIdentifier
			) { field, cell in
				guard
					// swiftlint:disable:next identifier_name
					let key = field.first?.key,
					let value = field[key] as? String else {return}
				cell.textLabel?.text = key
				cell.detailTextLabel?.text = value
			}
			self.dataSource.delegate = self
			self.tableView.delegate = self
			self.tableView.activityIndicatorView.startAnimating()
			self.tableView.dataSource = dataSource
			self.refreshControl = UIRefreshControl()
			refreshControl?.addTarget(
				self.dataSource,
				action: #selector(self.dataSource.fetchData),
				for: UIControl.Event.valueChanged
			)
			self.tableView.addSubview(refreshControl!)
			self.dataSource.fetchData()
		}
	}
}

extension ClaimDetailsTableViewController: ObjectLayoutDataSourceDelegate {
	func objectLayoutDataSourceDidUpdateFields(_ dataSource: ObjectLayoutDataSource) {
		DispatchQueue.main.async {
			self.tableView.reloadData()
			self.refreshControl?.endRefreshing()
			self.tableView.activityIndicatorView.stopAnimating()
		}
	}
}
