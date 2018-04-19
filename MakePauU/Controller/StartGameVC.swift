//
//  StartGameVC.swift
//  MakePauU
//
//  Created by 呂易軒 on 2018/4/11.
//  Copyright © 2018年 呂易軒. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StartGameVC: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    //origin
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var returnBtn: UIButton!
    @IBOutlet weak var confirmBtn: DLRadioButton!
    
    //enter
    @IBOutlet weak var baseView: UIView!

    //enter - data
    @IBOutlet weak var remainDistance: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var totalDistance: UILabel!
    @IBOutlet weak var remainTime: UILabel!
    @IBOutlet weak var remainNumber: UILabel!
    @IBOutlet weak var routeDistance: UILabel!
    @IBOutlet weak var routeTime: UILabel!
    
    
    @IBOutlet weak var topLeftView: UIView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var downLeftView: UIView!
    @IBOutlet weak var ARButton: UIButton!
    @IBOutlet weak var exitButton: UIButton!
    
    
    @IBOutlet weak var blackView: UIView!
    
    
    //downleft
    @IBOutlet weak var placeholder: UIImageView!
    @IBOutlet weak var title1: UILabel!
    @IBOutlet weak var title2: UILabel!
    @IBOutlet weak var downLeftExpandBtn: UIButton!
    
    
    //接應countDown
    lazy var countDown: CountDownVC = {
        let cd = CountDownVC()
        cd.startGameVC = self
        return cd
    }()
    
    //等待倒數
    var timer = Timer()
    var count = 2 //倒數時間
    
    var timerForRoute = Timer()
    var countForRoute = 5
    
    var timerForRoute2 = Timer()
    var countForRoute2 = 5
    
    var timerForGame = Timer()
    var countForGame = 0.0
    
    //圈
    var circle: MKCircle!
    
    //路徑
    var route: MKRoute!
    var locationCoordinate: CLLocationCoordinate2D!
    var distance: CLLocationDistance!
    var expectedTime: TimeInterval!
    
    //downleft
    var ifExpanded = true
    
    
    //location manager
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        
        downLeftExpandBtn.backgroundColor = UIColor(white: 1, alpha: 0.6)

        mapView.userTrackingMode = MKUserTrackingMode.follow
        
        print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
        locationManager.startUpdatingLocation()
    }
    
    
    // * authorize or request authorization
    func locationAuthStatus(){
        
        // 沒有點開時不要追蹤
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse{
            mapView.showsUserLocation = true
        } else {
            // 設定info.plist!!!!!!! privacy - location when in used(pop-out message)
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    //tell the delegate that the authorization status was changed
    //from CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .authorizedWhenInUse{
            
            mapView.showsUserLocation = true
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        let region = MKCoordinateRegion(center: center, span: span)
        
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
    }
    
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        
        // create the alert
        let alert = UIAlertController(title: "確定離開房間？", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func confirmBtnPressed(_ sender: DLRadioButton) {
        
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            //狀態改變
            self.timerLabel.isHidden = false
        }
        
        setTimer_Waiting()
    }
    
    
    @IBAction func downLeftExpandBtnPressed(_ sender: UIButton) {
        
        ifExpanded = !ifExpanded
        
        if ifExpanded == true{
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.downLeftView.frame = CGRect(x: 0, y: self.downLeftView.frame.origin.y, width: 0, height: 50)
                self.downLeftExpandBtn.frame = CGRect(x: 0, y: self.downLeftExpandBtn.frame.origin.y, width: 50, height: 50)
                self.placeholder.isHidden = true
                self.title1.isHidden = true
                self.title2.isHidden = true
                self.routeDistance.isHidden = true
                self.routeTime.isHidden = true
                
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.downLeftView.frame = CGRect(x: 0, y: self.downLeftView.frame.origin.y, width: 143, height: 50)
                self.downLeftExpandBtn.frame = CGRect(x: 143, y: self.downLeftExpandBtn.frame.origin.y, width: 50, height: 50)
                self.placeholder.isHidden = false
                self.title1.isHidden = false
                self.title2.isHidden = false
                self.routeDistance.isHidden = false
                self.routeTime.isHidden = false
                
            }, completion: nil)
        }
    }
    
    @IBAction func exitBtnPressed(_ sender: Any) {
        // create the alert
        let alert = UIAlertController(title: "確定離開房間？", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            GameStatus.sharedInstance.ifStarted = false
            self.dismiss(animated: true, completion: nil)
        }))
        
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ARBtnPressed(_ sender: Any) {
    }
    
    
    @IBAction func unwindFromFinalConfirm(_ sender: UIStoryboardSegue){
        
        print(StartStatus.sharedInstance.ifEntered)
        
        if StartStatus.sharedInstance.ifEntered == false{
            dismiss(animated: true, completion: nil)
        } else {
            
            DispatchQueue.main.async {
                self.countDown.showSetting()
            }
            countDown.dismiss()
            
            hideOriginView()
            showEnterView()
            
            // 先預設
            let location = CLLocation(latitude: 24.9863769611342 as CLLocationDegrees, longitude: 121.576758940876 as CLLocationDegrees)
            addRadiusCircle(location: location)
            
            annotationWork()
        }
    }
    
    func hideOriginView(){
        
        timerLabel.isHidden = true 
        returnBtn.isHidden = true
        confirmBtn.isHidden = true
    }
    
    func showEnterView(){
        
        baseView.isHidden = false
        topLeftView.isHidden = false
        topRightView.isHidden = false
        downLeftView.isHidden = false
        downLeftExpandBtn.isHidden = false
        exitButton.isHidden = false
        ARButton.isHidden = false
    }
    
    
    // draw circle
    func addRadiusCircle(location: CLLocation){
        circle = MKCircle(center: location.coordinate, radius: 300 as CLLocationDistance)
        self.mapView.add(circle)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //custom circle
        if let overlay = overlay as? MKCircle {
            
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(white: 0.3, alpha: 0.3)
            return circle
          
        } else {

            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(netHex: 0x007AFF)
            renderer.lineWidth = 5.0
            return renderer
        }
    }
    
    
    
    // set Timer
    func setTimer_Waiting(){
        //Timer (呼叫 updateTimer every second)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setTimer_Route(){
        
        timerForRoute = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateRouteData), userInfo: nil, repeats: true)
    }
    
    func setTimer_Route2(){
        
        timerForRoute2 = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(updateRouteData2), userInfo: nil, repeats: true)
    }
    
    func setTimer_Game(){
        
        timerForGame = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startGameTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){

        if count >= 0 {
            let seconds = String(count % 60)
            timerLabel.text = seconds
            count = count - 1
        } else {
            
            // 設定if pressed / if not pressed的處理
            performSegue(withIdentifier: "toFinalConfirmVC", sender: nil)
            
            timer.invalidate()
        }
    }

    @objc func updateRouteData(){
        
        self.disPlayRouteInfo()
        timerForRoute.invalidate()
    }
    
    @objc func updateRouteData2(){
        
        
        self.disPlayRouteInfo()
        self.timerForRoute2.invalidate()
    }
    
    @objc func startGameTimer(){
        
        countForGame = countForGame + 1.0
        time.text = "\(Int(Double(countForGame / 60)))'\(Int(round(Double(countForGame.truncatingRemainder(dividingBy: 60)))))''"
        
        if !GameStatus.sharedInstance.ifStarted {
            timerForGame.invalidate()
        }
    }
    
    
    
    
    // set annotation
    func annotationWork(){
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setAnnotation))
        mapView.addGestureRecognizer(gestureRecognizer)
        
    }
    
    @objc func setAnnotation(gestureRecognizer: UITapGestureRecognizer){
        
        let touchLocation = gestureRecognizer.location(in: mapView)
        locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        //print("Tapped at lat: \(locationCoordinate.latitude) long: \(locationCoordinate.longitude)")
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                //add annotation and route
                if self.mapView.annotations.count <= 1 {
                    
                    //第一個
                    self.mapView.addAnnotation(annotation)
                    self.setRoute(locationCoordinate: self.locationCoordinate)
                    
                    self.setTimer_Route()
                    
                } else {
                    
                    //刪掉上一個
                    for i in 0...self.mapView.annotations.count - 2{
                        self.mapView.removeAnnotation(self.mapView.annotations[i])
                        sleep(UInt32(0.01))
                    }
                    
                    //加入下一個
                    self.mapView.addAnnotation(annotation)
                    self.setRoute(locationCoordinate: self.locationCoordinate)
                    
                    self.setTimer_Route2()
                    
                    for j in 0...self.mapView.overlays.count - 2{
                        self.mapView.remove(self.mapView.overlays[j])
                        sleep(UInt32(0.01))
                    }
                }
            }
        }
    }

    
    //set route
    func setRoute(locationCoordinate: CLLocationCoordinate2D){
        
        let sourcePlaceMark = MKPlacemark(coordinate: mapView.userLocation.coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: locationCoordinate)
        
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)
        directionRequest.transportType = .walking
        
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {
                
                if let error = error{
                    print(error.localizedDescription)
                }
                
                print("didn't get response")
                return
            }
            
            //routes[0] -> fastest
            self.route = directionResponse.routes[0]
            self.mapView.add(self.route.polyline, level: .aboveRoads)
            
            //add it to the map
            let rect = self.route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            
            self.distance = self.route.distance
            self.expectedTime = self.route.expectedTravelTime
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //確定不是自己
        guard !annotation.isKind(of: MKUserLocation.self) else {
            return nil
        }
    
        let annotationIdentifier = "AnnotationIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        //if annotation is not nill
        
        annotationView?.image = UIImage(named: "placeholder-1")
        
        return annotationView
    }
    
    
    //display Route Data
    func disPlayRouteInfo(){
        
        if routeDistance != nil && routeTime != nil{
            
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.placeholder.isHidden = false
                self.title1.isHidden = false
                self.title2.isHidden = false
                self.routeDistance.isHidden = false
                self.routeTime.isHidden = false
            }, completion: nil)
            
            routeDistance.text = "\(Int(self.distance!)) M"
            routeTime.text = "\(Int(Double(self.expectedTime / 60)))'\(Int(round(Double(self.expectedTime.truncatingRemainder(dividingBy: 60)))))''"
        } else {
            return
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toFinalConfirmVC"{
            _ = segue.destination as! FinalConfirmVC
        }
    }
}