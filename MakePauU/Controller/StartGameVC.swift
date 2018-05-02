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
    
    
    //constraint
    @IBOutlet weak var downLeftWidthConstraint: NSLayoutConstraint!
    
    
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
    
    //user location
    var mapHasCenteredInBeginning = false
    
    
    //total travel distance
    var startLocation: CLLocation!
    var lastLocation: CLLocation!
    var traveledDistance: Double = 0
    
    
    //location manager
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        
        setCalaulateTotalDistance()
        
        downLeftExpandBtn.backgroundColor = UIColor(white: 1, alpha: 0.75)

    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        locationAuthStatus()
        locationManager.startUpdatingLocation()
    }
    
    func setCalaulateTotalDistance(){
        if CLLocationManager.locationServicesEnabled(){
            
            mapView.userTrackingMode = MKUserTrackingMode.follow
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
            locationManager.startMonitoringSignificantLocationChanges()
            locationManager.distanceFilter = 10
        }
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
    
    
    //讓user的location在畫面的正中間
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        //這邊處理，when updates come in, 'mapView.userTrackingMode = MKUserTrackingMode.follow' 處理追蹤。
        //然而，又不希望永遠保持追蹤，因為可能會想滑到其他地方看看 -> 第一時間要置中、其他時間按了球球再回來 -> bool 判斷！
        if let userLoc = userLocation.location{
            
            if mapHasCenteredInBeginning == false {
                
                centerMapOnLocation(location: userLoc)
                mapHasCenteredInBeginning = true
            }
        }
    }
    
    
      func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    
        if GameStatus.sharedInstance.ifStarted == true {
            
            print("!!!!!!!!!!!!!!!!!!!!!!!!!")
            if startLocation == nil {
                startLocation = locations.first
            } else if let location = locations.last {
                traveledDistance += lastLocation.distance(from: location)
                print("Traveled Distance:",  traveledDistance)
                
                let toKm = traveledDistance / 1000.0
                
                totalDistance.text = String(format: "%.2f", toKm)
            }
            
            lastLocation = locations.last
        } else {
            print("Not Yet")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if (error as? CLError)?.code == .denied {
            manager.stopUpdatingLocation()
            manager.stopMonitoringSignificantLocationChanges()
        }
    }
    
    
    
    //讓user的location在畫面的正中間
    func centerMapOnLocation(location: CLLocation){
        
        //(2000, 2000) is the region that we want to capture
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1500, 1500)
        
        mapView.setRegion(coordinateRegion, animated: true)
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
        
        if !ifExpanded{
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.downLeftWidthConstraint.constant = 0
                self.downLeftExpandBtn.frame = CGRect(x: 0, y: self.downLeftExpandBtn.frame.origin.y, width: 50, height: 50)
                
                self.placeholder.isHidden = true
                self.title1.isHidden = true
                self.title2.isHidden = true
                self.routeDistance.isHidden = true
                self.routeTime.isHidden = true
                self.downLeftView.layoutIfNeeded()
            }, completion: nil)
            
        } else {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.downLeftWidthConstraint.constant = 143
                self.downLeftExpandBtn.frame = CGRect(x: 143, y: self.downLeftExpandBtn.frame.origin.y, width: 50, height: 50)
                
                
                self.placeholder.isHidden = false
                self.title1.isHidden = false
                self.title2.isHidden = false
                self.routeDistance.isHidden = false
                self.routeTime.isHidden = false
                self.downLeftView.layoutIfNeeded()
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
        performSegue(withIdentifier: "toARVCNew", sender: nil)
        
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
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.downLeftWidthConstraint.constant = 143
                self.downLeftExpandBtn.frame = CGRect(x: 143, y: self.downLeftExpandBtn.frame.origin.y, width: 50, height: 50)
                self.placeholder.isHidden = false
                self.title1.isHidden = false
                self.title2.isHidden = false
                self.routeDistance.isHidden = false
                self.routeTime.isHidden = false
                
                self.downLeftView.layoutIfNeeded()
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
        
        //toARVCNew
        if segue.identifier == "toARVCNew"{
            
            if let arVCNew = segue.destination as? ARVC_New, let loc = locationCoordinate, let dis = distance {
                arVCNew.locationCoordinate = loc
                arVCNew.distance = dis
            } else {
                print("no tag")
                _ = segue.destination as! ARVC_New
            }
        }
    }
}

//set Timer
extension StartGameVC{
    
    // set Timer
    func setTimer_Waiting(){
        //Timer (呼叫 updateTimer every second)
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    func setTimer_Route(){
        
        timerForRoute = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateRouteData), userInfo: nil, repeats: true)
    }
    
    func setTimer_Route2(){
        
        timerForRoute2 = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(updateRouteData2), userInfo: nil, repeats: true)
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
}
