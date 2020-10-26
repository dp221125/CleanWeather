//
//  MainViewController.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//
import CoreLocation
import UIKit

protocol MainDisplayLogic: class {
	func showErrorAlert(errorViewModel: Main.MainError.ViewModel)
}

class MainViewController: BaseViewController, MainDisplayLogic {
	
	var interactor: MainBusinessLogic?
	var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
	
	// MARK: Object lifecycle
	
	lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.tableFooterView = UIView()
		tableView.register(TodayCell.self, forCellReuseIdentifier: "\(TodayCell.self)")
		return tableView
	}()
	
	override init() {
		super.init()
		setup()
	}
	
	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}
	
	override func configureUI() {
		self.view.addSubview(tableView)
	}
	
	override func setupConstraints() {
		NSLayoutConstraint.activate([
			tableView.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor),
			tableView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor),
			tableView.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor),
			tableView.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor)
		])
	}
	
	// MARK: Setup
	
	private func setup() {
		let viewController = self
		
		let repository = MainRepository()
		let worker = MainWorker(mainRepository: repository)
		let interactor = MainInteractor(worker: worker)
		let presenter = MainPresenter()
		let router = MainRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}
	
	// MARK: View lifecycle
	override func viewDidLoad() {
		super.viewDidLoad()
		requestFetchData()

	}
	
	func requestFetchData() {
		
		let mockLocation = CLLocationCoordinate2D(latitude: 35.9084351,
												  longitude: 128.7990138)
		let request = Main.FetchWeather.Request(location: mockLocation,
												unit: "c")
		self.interactor?.fetchData(request: request)
	}
	
	func showErrorAlert(errorViewModel: Main.MainError.ViewModel) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: "Error", message: errorViewModel.localError, preferredStyle: .alert)
			let okAction = UIAlertAction(title: "확인", style: . default)
			alert.addAction(okAction)
			
			self.present(alert, animated: true)
		}
	}

}
