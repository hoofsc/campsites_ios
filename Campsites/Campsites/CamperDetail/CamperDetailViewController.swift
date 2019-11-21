//
//  CamperDetailViewController.swift
//  Campsites
//
//  Created by DH on 11/19/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class CamperDetailViewController: UIViewController {

    let context: CamperDetailContext

    var contentView: CamperDetailContentView {
        return view as? CamperDetailContentView ?? CamperDetailContentView()
    }


    // MARK: View Life Cycle

    internal init(context: CamperDetailContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        let msg = String(describing: type(of: self)) + " cannot be used with a nib file"
        fatalError(msg)
    }

    override func loadView() {
        view = CamperDetailContentView()
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
        let newAnnotation = CamperAnnotation(camper: context.camper)
        contentView.mapView.addAnnotation(newAnnotation)
    }

    func update(camper: Camper?) {
        guard let camper = camper else { return }
        contentView.mapView.setCenter(camper.location.coordinate, animated: true)
        let modAnno = contentView.mapView.annotations.filter {
            if let anno = $0 as? CamperAnnotation {
                return anno.camper.id == camper.id
            }
            return false
        }.first as? CamperAnnotation
        if modAnno != nil {
            modAnno!.camper = camper
        }
        updateDetail(camper: camper)
    }


    private func updateDetail(camper: Camper) {
        let name = "\(camper.firstName) \(camper.lastName)"
        let phone = camper.phone
        let location = String(
            format: "%.6f, %.6f", camper.location.coordinate.latitude, camper.location.coordinate.longitude)
        contentView.update(name: name, phone: phone, location: location)
    }

    private func setUpMap() {
        contentView.mapView.delegate = self
        contentView.mapView.register(MKAnnotationView.self,
                                     forAnnotationViewWithReuseIdentifier: "camperAnnotationView")
        contentView.mapView.setCenter(context.mapCenter, animated: false)
        contentView.mapView.setRegion(context.mapRegion, animated: false)
    }

    private func setUpNavBar() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "\(context.camper.firstName) \(context.camper.lastName)"
            return label
        }()
        navigationItem.titleView = titleLabel
    }

    private func subscribeToLocationEvents() {
        context.subscribeToCamperLocationEvents { [weak self] camper in
            DispatchQueue.main.async {
                self?.updateAnnotations()
            }
        }
    }
}


// MARK: MKMapViewDelegate

extension CamperDetailViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CamperAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "camperAnnotationView", for: annotation)
            view.annotation = annotation
            view.image = UIImage(named: "camperIcon")
            view.canShowCallout = false
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView, annotationCanShowCallout annotation: MKAnnotation) -> Bool {
        return false
    }
}
