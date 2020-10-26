//
//  BaseTableViewCell.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
	
	private(set) var didSetupConstaints = false
	
	// MARK: Initialization
	
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	
	// MARK: Func
	
	override func updateConstraints() {
		if !self.didSetupConstaints {
			self.setupConstraints()
			self.didSetupConstaints = true
		}
		super.updateConstraints()
	}
	
	func configure() {
		self.setNeedsUpdateConstraints()
	}
	
	func configureUI() {
		self.contentView.backgroundColor = .white
	}
	
	func setupConstraints() {}
}

