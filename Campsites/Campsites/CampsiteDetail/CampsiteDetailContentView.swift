//
//  CampsiteDetailContentView.swift
//  Campsites
//
//  Created by DH on 11/19/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class CampsiteDetailContentView: UIView {

    private(set) lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private(set) lazy var detailView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private(set) lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private(set) lazy var name: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.boldSystemFont(ofSize: 22.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private(set) lazy var desc: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 16.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private(set) lazy var status: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    private(set) lazy var location: UILabel = {
        let lbl = UILabel()
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()


    required init?(coder aDecoder: NSCoder) {
        let msg = String(describing: type(of: self)) + " cannot be used with a nib file"
        fatalError(msg)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
        setUpCustomSpacing()
    }


    func update(name: String, description: String, isClosed: Bool, location: String) {
        update(nameStr: name)
        update(descriptionStr: description)
        update(locationStr: location)
        update(isClosed: isClosed)
    }


    private func update(nameStr: String) {
        name.text = nameStr
    }

    private func update(descriptionStr: String) {
        desc.text = descriptionStr
    }

    private func update(locationStr: String) {
        location.text = locationStr
    }

    private func update(isClosed: Bool) {
        status.text = String(format: "Status: %@", isClosed ? "Closed" : "Open")
    }

    private func setUpCustomSpacing() {
        stackView.setCustomSpacing(5.0, after: name)
        stackView.setCustomSpacing(10.0, after: status)
        stackView.setCustomSpacing(10.0, after: desc)
    }

    private func setUpViews() {
        addSubview(mapView)
        addSubview(detailView)
            detailView.addSubview(stackView)
                stackView.addArrangedSubview(name)
                stackView.addArrangedSubview(status)
                stackView.addArrangedSubview(desc)
                stackView.addArrangedSubview(location)
    }

    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += [
            mapView.heightAnchor.constraint(equalToConstant: 400.0),
            mapView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        constraints += [
            detailView.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            detailView.leadingAnchor.constraint(equalTo: leadingAnchor),
            detailView.bottomAnchor.constraint(equalTo: bottomAnchor),
            detailView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        constraints += [
            stackView.topAnchor.constraint(equalTo: detailView.topAnchor, constant: 40.0),
            stackView.leadingAnchor.constraint(equalTo: detailView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: detailView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

