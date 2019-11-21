//
//  CampsiteDetailViewController.swift
//  Campsites
//
//  Created by DH on 11/19/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class CampsiteDetailViewController: UIViewController {

    let context: CampsiteDetailContext

    var contentView: CampsiteDetailContentView {
        return view as? CampsiteDetailContentView ?? CampsiteDetailContentView()
    }


    // MARK: View Life Cycle

    internal init(context: CampsiteDetailContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let msg = String(describing: type(of: self)) + " cannot be used with a nib file"
        fatalError(msg)
    }

    override func loadView() {
        view = CampsiteDetailContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpMap()
        subscribeToLocationEvents()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isMovingFromParent {
            context.destroyUI()
        }
    }


    func updateAnnotations() {
        let newAnnotation = CampsiteAnnotation(campsite: context.campsite)
        contentView.mapView.addAnnotation(newAnnotation)
    }

    func update(campsite: Campsite?) {
        guard let campsite = campsite else { return }
        contentView.mapView.setCenter(campsite.location.coordinate, animated: true)
        let modAnno = contentView.mapView.annotations.filter {
            if let anno = $0 as? CampsiteAnnotation {
                return anno.campsite.id == campsite.id
            }
            return false
        }.first as? CampsiteAnnotation
        if modAnno != nil {
            modAnno!.campsite = campsite
        }
        updateDetail(campsite: campsite)
    }


    private func updateDetail(campsite: Campsite) {
        let name = campsite.name
        let description = campsite.description
        let isClosed = campsite.isClosed
        let location = String(
            format: "%.6f, %.6f", campsite.location.coordinate.latitude, campsite.location.coordinate.longitude)
        contentView.update(name: name, description: description, isClosed: isClosed, location: location)
    }

    private func setUpMap() {
        contentView.mapView.delegate = self
        contentView.mapView.register(MKAnnotationView.self,
                                     forAnnotationViewWithReuseIdentifier: "campsiteAnnotationView")
        contentView.mapView.setCenter(context.mapCenter, animated: false)
        contentView.mapView.setRegion(context.mapRegion, animated: false)
    }

    private func setUpNavBar() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = context.campsite.name
            return label
        }()
        navigationItem.titleView = titleLabel
    }

    private func subscribeToLocationEvents() {
        context.subscribeToCampsiteLocationEvents { [weak self] campsite in
            DispatchQueue.main.async {
                self?.updateAnnotations()
            }
        }
    }
}


// MARK: MKMapViewDelegate

extension CampsiteDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CampsiteAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "campsiteAnnotationView", for: annotation)
            view.annotation = annotation
            view.image = UIImage(named: "campsiteIcon")
            view.canShowCallout = false
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationCanShowCallout annotation: MKAnnotation) -> Bool {
        return false
    }
}

