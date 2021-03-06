//
//  TodayCell.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import UIKit

class TodayCell: BaseTableViewCell {
	
	weak var cache: NSCache<NSString, NSData>?
	
	private let cityLabel: UILabel = {
		let cityLabel = UILabel()
		cityLabel.font = .boldSystemFont(ofSize: 36)
		cityLabel.textColor = .label
		cityLabel.translatesAutoresizingMaskIntoConstraints = false
		return cityLabel
	}()
	
	private let regionLabel: UILabel = {
		let regionLabel = UILabel()
		regionLabel.font = .systemFont(ofSize: 18)
		regionLabel.textColor = .label
		regionLabel.translatesAutoresizingMaskIntoConstraints = false
		return regionLabel
	}()
	
	private let weatherLabel: UILabel = {
		let weatherLabel = UILabel()
		weatherLabel.font = .systemFont(ofSize: 16)
		weatherLabel.textColor = .label
		weatherLabel.translatesAutoresizingMaskIntoConstraints = false
		return weatherLabel
	}()
	
	private let bottomStackView: UIStackView = {
		let bottomStackView = UIStackView()
		bottomStackView.axis = .horizontal
		bottomStackView.distribution = .fillEqually
		bottomStackView.translatesAutoresizingMaskIntoConstraints = false
		return bottomStackView
	}()
	
	private let tempLabel: UILabel = {
		let tempLabel = UILabel()
		tempLabel.font = .systemFont(ofSize: 48)
		tempLabel.textColor = .label
		tempLabel.translatesAutoresizingMaskIntoConstraints = false
		tempLabel.textAlignment = .center
		return tempLabel
	}()
	
	private let weatherImageView: UIImageView = {
		let weatherImageView = UIImageView()
		weatherImageView.contentMode = .scaleAspectFit
		weatherImageView.translatesAutoresizingMaskIntoConstraints = false
		return weatherImageView
	}()
	
	private let lineView: UIView = {
		let lineView = UIView()
		lineView.backgroundColor = .systemOrange
		lineView.translatesAutoresizingMaskIntoConstraints = false
		return lineView
	}()
	
	func configure(cache: NSCache<NSString, NSData>) {
		super.configure()
		self.cache = cache
	}
	
	override func configureUI() {
		super.configureUI()
		
		defer {
			self.setupConstraints()
		}
		
		[cityLabel, regionLabel, weatherLabel, bottomStackView, lineView].forEach {
			self.contentView.addSubview($0)
		}
		
		[tempLabel,weatherImageView].forEach {
			self.bottomStackView.addArrangedSubview($0)
		}
		
	}
	
	override func setupConstraints() {
		
		NSLayoutConstraint.activate([
			cityLabel.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
			cityLabel.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 16),
		])
		
		NSLayoutConstraint.activate([
			regionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 8),
			regionLabel.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor)
		])
		
		NSLayoutConstraint.activate([
			weatherLabel.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
			weatherLabel.topAnchor.constraint(equalTo: regionLabel.bottomAnchor, constant: 8),
		])
		
		NSLayoutConstraint.activate([
			bottomStackView.centerXAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.centerXAnchor),
			bottomStackView.topAnchor.constraint(equalTo: weatherLabel.bottomAnchor, constant: 8),
			bottomStackView.widthAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.widthAnchor, constant: -32),
		])
		
		NSLayoutConstraint.activate([
			lineView.centerXAnchor.constraint(equalTo: self.bottomStackView.centerXAnchor),
			lineView.centerYAnchor.constraint(equalTo: self.bottomStackView.centerYAnchor),
			lineView.widthAnchor.constraint(equalToConstant: 2),
			lineView.heightAnchor.constraint(equalTo: self.bottomStackView.heightAnchor, constant: -8)
		])
		
	}
	
	func bindUI(todayDTO: TodayDTO) {

		DispatchQueue.main.async {
			
			if let imageData = self.cache?.object(forKey: String(todayDTO.weatherCode) as NSString ) {
				DispatchQueue.main.async {
					self.weatherImageView.image = UIImage(data: imageData as Data)
				}
				
			}
			
			self.cityLabel.text = todayDTO.cityName
			self.regionLabel.text = todayDTO.regionName
			self.weatherLabel.text = todayDTO.weather
			
			self.tempLabel.text = todayDTO.temp
			
			DispatchQueue.global().async {
				if let iamgeURL = URL(string: "http://l.yimg.com/a/i/us/we/52/\(todayDTO.weatherCode).gif"),
				   let weatherImageData = try? Data(contentsOf: iamgeURL) {
					DispatchQueue.main.async {
						self.cache?.setObject(weatherImageData as NSData, forKey: String(todayDTO.weatherCode) as NSString )
						self.weatherImageView.image = UIImage(data: weatherImageData)
					}
					
				}
			}

			
		}
		
	}
	
	override func prepareForReuse() {
		self.weatherImageView.image = nil
	}
}
