//
//  NGEventListCollectionViewCell.swift
//  NeighborhoodGems
//
//

import UIKit

class NGEventListCollectionViewCell: UICollectionViewCell {
     enum Constants {
        static let contentViewCornerRadius: CGFloat = 4.0
        static let imageWidth: CGFloat = 160.0
        static let imageHeight: CGFloat = 100.0
        static let verticalSpacing: CGFloat = 8.0
        static let horizontalPadding: CGFloat = 16.0
        static let placeVerticalPadding: CGFloat = 64.0
    }
    
    //Placeholder url to be replaced with event url: this will allow us to open an event URL
    var url: String  = {
        let url = "https://wwww.google.com"
        return url
    }()
    
    private lazy var eventNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textColor = .black
        label.font = UIFont(name: "Futura", size: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 4
        return label
    }()
     
    
    private lazy var eventDateLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .black
        return label
    }()
    
    private lazy var eventURLLabel: UILabel = {
        let urlLabel = UILabel()
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(self.urlLabelClicked(_:)))
        urlLabel.textColor = .blue
        urlLabel.textAlignment = .center
        //Adding gesture recognizer
        urlLabel.isUserInteractionEnabled = true
        urlLabel.addGestureRecognizer(labelTap)
        return urlLabel
    }()
    
    @objc func urlLabelClicked(_ sender: UITapGestureRecognizer) {
        let url = URL(string: self.url)
        if sender.view == self.eventURLLabel {
           UIApplication.shared.open(url!, options: [:]) { (success: Bool) in
               // ... handle the result
           }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupViews()
        setupLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Populate each cell with data coming from the eventsList in NGDataHelper
    func populate(with event: NGEvent) {
        eventNameLabel.text = event.name
        eventDateLabel.text = event.dates.start.localDate
        self.url = event.url
        eventURLLabel.text = "Link to Event"
    }
    

    
    private func setupViews() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = Constants.contentViewCornerRadius
        contentView.backgroundColor = .white

        contentView.addSubview(eventNameLabel)
        contentView.addSubview(eventDateLabel)
        contentView.addSubview(eventURLLabel)
    
    }
    
    private func setupLayouts() {
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventURLLabel.translatesAutoresizingMaskIntoConstraints = false

      
        NSLayoutConstraint.activate([
            eventNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
           eventNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
           eventNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12.0)
        ])
        
        
        NSLayoutConstraint.activate([
            eventDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            eventDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            eventDateLabel.topAnchor.constraint(equalTo: eventNameLabel.bottomAnchor, constant: 12.0)
        ])
        
        NSLayoutConstraint.activate([
            eventURLLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8.0),
            eventURLLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.horizontalPadding),
            eventURLLabel.topAnchor.constraint(equalTo: eventDateLabel.bottomAnchor, constant: 12.0)
        ])
    }
}
