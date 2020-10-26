//
//  MainInteractor.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

import RxSwift

protocol MainBusinessLogic {
	func fetchData(request: Main.FetchWeather.Request)
}

protocol MainDataStore {
	//var name: String { get set }
}

class MainInteractor: MainBusinessLogic, MainDataStore {
	
	var presenter: MainPresentationLogic?
	private let worker: MainWorker?
	private var disposeBag: DisposeBag = DisposeBag()
	
	init(worker: MainWorker) {
		self.worker = worker
	}
	
	func fetchData(request: Main.FetchWeather.Request) {
		self.worker?.fetchData(request: request)
			.subscribe(onNext: { weather in
				print(weather)
			}, onError: { error in
				let response = Main.MainError.Response(error: error)
				self.presenter?.showErrorAlert(errorResponse: response)
			}).disposed(by: disposeBag)
	}

}
