//
//  ForecastCell.swift
//  CleanWeahter
//
//  Created by Seokho on 2020/10/26.
//

import UIKit

class Cache {
	
	let imageCache: NSCache<NSString, NSData>
	
	init() {
		self.imageCache = NSCache<NSString, NSData>()
	}
	
}

class ForecastCell: BaseTableViewCell {
	
	weak var cache: Cache?
	
	let weekendLabel: UILabel = {
		let weekendLabel = UILabel()
		weekendLabel.textColor = .label
		weekendLabel.font = .systemFont(ofSize: 24)
		weekendLabel.translatesAutoresizingMaskIntoConstraints = false
		return weekendLabel
	}()
	
	let dateLabel: UILabel = {
		let dateLabel = UILabel()
		dateLabel.textColor = .label
		dateLabel.font = .systemFont(ofSize: 16)
		dateLabel.translatesAutoresizingMaskIntoConstraints = false
		return dateLabel
	}()
	
	let minMaxTempLabel: UILabel = {
		let minMaxTempLabel = UILabel()
		minMaxTempLabel.textColor = .label
		minMaxTempLabel.font = .systemFont(ofSize: 24)
		minMaxTempLabel.translatesAutoresizingMaskIntoConstraints = false
		return minMaxTempLabel
	}()
	
	let weatherImageView: UIImageView = {
		let weatherImageView = UIImageView()
		weatherImageView.contentMode = .scaleAspectFit
		weatherImageView.translatesAutoresizingMaskIntoConstraints = false
		return weatherImageView
	}()
	
	func configure(cache: Cache) {
		super.configure()
		self.cache = cache
	}
	
	override func configureUI() {
		super.configureUI()
		
		defer {
			self.setupConstraints()
		}
		
		[weekendLabel, dateLabel, minMaxTempLabel, weatherImageView].forEach {
			self.contentView.addSubview($0)
		}
	}
	
	override func setupConstraints() {
		
		NSLayoutConstraint.activate([
			weekendLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16),
			weekendLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 16)
		])
		
		NSLayoutConstraint.activate([
			dateLabel.topAnchor.constraint(equalTo: weekendLabel.bottomAnchor, constant: 8),
			dateLabel.leadingAnchor.constraint(equalTo: weekendLabel.leadingAnchor)
		])
		
		NSLayoutConstraint.activate([
			minMaxTempLabel.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
			minMaxTempLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
		])
		
		NSLayoutConstraint.activate([
			weatherImageView.widthAnchor.constraint(equalToConstant: 44),
			weatherImageView.heightAnchor.constraint(equalTo: weatherImageView.widthAnchor),
			weatherImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
			weatherImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16)
		])
	
	}
	
	func bindUI(dto: ForecastDTO) {
		
		DispatchQueue.main.async {
			self.weekendLabel.text = dto.weekend
			
			let dateFormatter = DateFormatter()
			dateFormatter.dateFormat = "MMM dd일"
			dateFormatter.locale = Locale(identifier: "ko-KR")
			self.dateLabel.text = dateFormatter.string(from: dto.date)
			
			self.minMaxTempLabel.text = dto.temp
			
			DispatchQueue.global().async {
				if let imageData = self.cache?.imageCache.object(forKey: String(dto.weatherCode) as NSString ) {
					DispatchQueue.main.async {
						self.weatherImageView.image = UIImage(data: imageData as Data)
					}
					
				}
				
				if let iamgeURL = URL(string: "http://l.yimg.com/a/i/us/we/52/\(dto.weatherCode).gif"),
				   let weatherImageData = try? Data(contentsOf: iamgeURL) {
					DispatchQueue.main.async {
						self.cache?.imageCache.setObject(weatherImageData as NSData, forKey: String(dto.weatherCode) as NSString )
						self.weatherImageView.image = UIImage(data: weatherImageData)
					}
					
				}
			}

		}

	}
	
	override func prepareForReuse() {
		super.prepareForReuse()

		self.weekendLabel.text = ""
		self.minMaxTempLabel.text = ""
		self.dateLabel.text = ""
		self.weatherImageView.image = nil
	}
}
