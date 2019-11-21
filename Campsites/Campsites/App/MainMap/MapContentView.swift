//
//  MapContentView.swift
//  Campsites
//
//  Created by DH on 11/9/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

class MapContentView: UIView {

    private(set) lazy var mapView: MKMapView = {
        let view = MKMapView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    required init?(coder aDecoder: NSCoder) {
        let msg = String(describing: type(of: self)) + " cannot be used with a nib file"
        fatalError(msg)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }


    private func setUpViews() {
        addSubview(mapView)
    }

    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        constraints += [
            mapView.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}
