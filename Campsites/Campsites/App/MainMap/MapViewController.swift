//
//  MapViewController.swift
//  Campsites
//
//  Created by DH on 11/9/19.
//  Copyright © 2019 Retinal Media. All rights reserved.
//

import UIKit
import MapKit

internal class MapViewController: UIViewController {
    
    let context: MainMapContext
    
    var contentView: MapContentView {
        return view as? MapContentView ?? MapContentView()
    }
    var campsiteAnnotations = [CampsiteAnnotation]()
    

    internal init(context: MainMapContext) {
        self.context = context
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let msg = String(describing: type(of: self)) + " cannot be used with a nib file"
        fatalError(msg)
    }
    
    override func loadView() {
        view = MapContentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpMap()
        subscribeToLocationEvents()
        setUpUpdates()
    }


    func removeAnnotations() {
        contentView.mapView.removeAnnotations(contentView.mapView.annotations)
    }

    func updateCamperAnnotations() {
        var newCamperAnnotations = [CamperAnnotation]()
        for camper in context.campers {
            let modCamperAnno = contentView.mapView.annotations.filter {
                if let anno = $0 as? CamperAnnotation {
                    return anno.camper.id == camper.id
                }
                return false
            }.first as? CamperAnnotation
            if modCamperAnno != nil {
                modCamperAnno!.camper = camper
            } else {
                let newCamperAnnotation = CamperAnnotation(camper: camper)
                newCamperAnnotations.append(newCamperAnnotation)
            }
        }
        contentView.mapView.addAnnotations(newCamperAnnotations)
    }

    func updateCampsiteAnnotations() {
        for campsite in context.campsites {
            let newCampsiteAnnotation = CampsiteAnnotation(campsite: campsite)
            campsiteAnnotations.append(newCampsiteAnnotation)
        }
        contentView.mapView.addAnnotations(campsiteAnnotations)
    }

    func update(camper: Camper) {
        var newCamperAnnotations = [CamperAnnotation]()
        let modCamperAnno = contentView.mapView.annotations.filter {
           if let anno = $0 as? CamperAnnotation {
               return anno.camper.id == camper.id
           }
           return false
       }.first as? CamperAnnotation
        if modCamperAnno != nil {
            modCamperAnno!.camper = camper
        } else {
            let newCamperAnnotation = CamperAnnotation(camper: camper)
            newCamperAnnotations.append(newCamperAnnotation)
        }
        if newCamperAnnotations.count > 0 {
            contentView.mapView.addAnnotations(newCamperAnnotations)
        }
    }

    
    private func setUpMap() {
        contentView.mapView.delegate = self
        contentView.mapView.register(MKAnnotationView.self,
                                     forAnnotationViewWithReuseIdentifier: "campsiteAnnotationView")
        contentView.mapView.register(MKAnnotationView.self,
                                     forAnnotationViewWithReuseIdentifier: "camperAnnotationView")
        contentView.mapView.setCenter(context.mapCenter, animated: false)
        contentView.mapView.setRegion(context.mapRegion, animated: false)
    }

    private func setUpNavBar() {
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = NSLocalizedString("Campsites", comment: "Title of Map screen.")
            return label
        }()
        navigationItem.titleView = titleLabel
    }

    private func setUpUpdates() {
        context.beginLocationUpdates()
    }

    private func subscribeToLocationEvents() {
        context.subscribeToCamperLocationEvents { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateCamperAnnotations()
            }
        }
        context.fetchCampsiteLocations { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateCampsiteAnnotations()
            }
        }
    }
}


// MARK: MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? CampsiteAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "campsiteAnnotationView", for: annotation)
            view.annotation = annotation
            view.image = UIImage(named: "campsiteIcon")
            view.canShowCallout = true
            view.displayPriority = .required
            let rightButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = rightButton
            return view
        }
        if let annotation = annotation as? CamperAnnotation {
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "camperAnnotationView", for: annotation)
            view.annotation = annotation
            view.image = UIImage(named: "camperIcon")
            view.canShowCallout = true
            view.clusteringIdentifier = "camper"
            view.displayPriority = .defaultHigh
            let rightButton = UIButton(type: .detailDisclosure)
            view.rightCalloutAccessoryView = rightButton
            return view
        }
        return nil
    }

    func mapView(_ mapView: MKMapView,
                 annotationView view: MKAnnotationView,
                 calloutAccessoryControlTapped control: UIControl) {
        if let annotation = view.annotation as? CamperAnnotation {
            let camper = annotation.camper
            context.presentCamperDetail(camper: camper)
        }
        if let annotation = view.annotation as? CampsiteAnnotation {
            let campsite = annotation.campsite
            context.presentCampsiteDetail(campsite: campsite)
        }
    }
}
