//
//  MainPresenter.swift
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

protocol MainPresentationLogic {
	func displayTableView(response: Main.FetchWeather.Response)
}

class MainPresenter: MainPresentationLogic {

	weak var viewController: MainDisplayLogic?
	
	func displayTableView(response: Main.FetchWeather.Response) {
        
        if let error = response.error {
            let viewModel = Main.FetchWeather.ViewModel(error: error)
            viewController?.showErrorAlert(viewModel: viewModel)
        } else if let weather = response.weather {
            let viewModel = Main.FetchWeather.ViewModel(weather: weather)
            viewController?.reloadData(viewModel: viewModel)
        }

	}
	
}
