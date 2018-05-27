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
    @IBOutlet weak var confirmBtn: DLRadioButton!
    @IBOutlet weak var returnBtn: UIButton!
    
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
    
    //topleft
    @IBOutlet weak var countDownView: CountDownView!
    @IBOutlet weak var countDownLbl: UILabel!
    
    
    
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
    var count =  0 //倒數時間
    
    //延遲route
    var timerForRoute = Timer()
    var countForRoute = 5
    
    //延遲route2
    var timerForRoute2 = Timer()
    var countForRoute2 = 5
    
    //跑步計時器
    var timerForGame = Timer()
    var countForGame = 0.0
    
    //等待時間
    var timerForCluster = Timer()
    var countForCluster = 0.0
    var ifClustered: Bool!
    
    //縮圈控制
    var timerForCircle = Timer()
    var countForCircle = 10.0 //第一次的時間
    var term: Int = 0 // 0 for the first time, 1 for the second time...
    
    //距離縮圈(每兩秒呼叫一次)
    var timerForDistanceToCircle = Timer()
    
    //出局控制
    var timerForOut = Timer()
    var countForOut = 20.0

    //圈
    var circle: MKCircle!
    var distanceToCircle: Double = 0.0
    
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

    
    var locations: [CLLocation] = []
    var statsInfo = StatsInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
        mapView.delegate = self
        
        setCalaulateTotalDistance()
        setMapView()
        
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
    
    func setMapView(){
        
        mapView.showsCompass = false
        
        let compassBtn = MKCompassButton(mapView:mapView)
        compassBtn.frame.origin = CGPoint(x: self.view.frame.width - 48, y: self.view.frame.height - 176)
        compassBtn.compassVisibility = .adaptive
        self.view.addSubview(compassBtn)
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
    
    
    @IBAction func confirmBtnPressed(_ sender: DLRadioButton) {
        
        returnBtn.isHidden = false
        
        ApiService.sharedInstance.postUserPosition(userLocation: self.mapView.userLocation.coordinate, completion: {
            
            while self.ifClustered != true {
                    
                FirebaseService.sharedInstance.checkIfCluster { (ifSuccess, numberOfMates) in
                    self.ifClustered = ifSuccess
                        
                    self.remainNumber.text = "\(numberOfMates) / \(numberOfMates)"
                        
                    if ifSuccess == true {
                        self.timer.invalidate()
                        self.performSegue(withIdentifier: "toFinalConfirmVC", sender: nil)
                    }
                }
        
                if self.ifClustered != true {
                    sleep(20)
                } else {
                    break
                }
            }
        })
        
        
        
        //如果配對成功的結果
        UIView.animate(withDuration: 0.3) {
            self.blackView.alpha = 0
            self.timerLabel.isHidden = false
        }
        
        self.setTimer_Waiting()
    }
    
    @IBAction func returnBtnPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "確定離開配對？", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            
            ApiService.sharedInstance.delete_from_main_pool {
                EnterRoomStatus.sharedInstance.ifEnteredRoom = false
                GameStatus.sharedInstance.ifStarted = false
            }
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
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
            
            self.gatherFigure {
                ApiService.sharedInstance.during_game_cancel(statsInfo: self.statsInfo, completion: {
                    
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func ARBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: "toARVCNew", sender: nil)
        
        print("!!!!!!!!!!!!!!!!!!!\(mapView.overlays)")
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
            
            setRouteAnnotation()
        }
    }
    
    func hideOriginView(){
        
        timerLabel.isHidden = true 
        confirmBtn.isHidden = true
        returnBtn.isHidden = true
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
    func addRadiusCircle(location: CLLocation, radius: Int){
        circle = MKCircle(center: location.coordinate, radius: CLLocationDistance(radius))
        self.mapView.add(circle)
    }
    
    // 縮圈設定
    func setFirstCircle(){
        FirebaseService.sharedInstance.setCircle(completion: { (locations) in
            
            self.locations = locations
            
            let centre1: CLLocation = locations[0]
            self.addRadiusCircle(location: centre1, radius: 3000)
            
            let centre2: CLLocation = locations[1]
            self.addRadiusCircle(location: centre2, radius: 1500)

            let centre3: CLLocation = locations[2]
            self.addRadiusCircle(location: centre3, radius: 750)

            let centre4: CLLocation = locations[3]
            self.addRadiusCircle(location: centre4, radius: 100)
            
            self.mapView.renderer(for: self.mapView.overlays[2])?.alpha = 0
            self.mapView.renderer(for: self.mapView.overlays[3])?.alpha = 0
            
        })
        
        FirebaseService.sharedInstance.setAirDrop { (airdropLocs, gifts) in
            print(airdropLocs)
            print(gifts)
            
            let firstAirDrop = AirDropAnnotation(coordinate: airdropLocs[0].coordinate)
            self.mapView.addAnnotation(firstAirDrop)

            let secondAirDrop = AirDropAnnotation(coordinate: airdropLocs[1].coordinate)
            self.mapView.addAnnotation(secondAirDrop)

            let thirdAirDrop = AirDropAnnotation(coordinate: airdropLocs[2].coordinate)
            self.mapView.addAnnotation(thirdAirDrop)
            
            print(self.mapView.annotations)
        }
    }
    
    func setSecondCircle(){
        self.mapView.renderer(for: self.mapView.overlays[mapView.overlays.count - 4])?.alpha = 0
        self.mapView.renderer(for: self.mapView.overlays[mapView.overlays.count - 2])?.alpha = 1
    }
    
    func setThirdCircle(){
        self.mapView.renderer(for: self.mapView.overlays[mapView.overlays.count - 3])?.alpha = 0
        self.mapView.renderer(for: self.mapView.overlays[mapView.overlays.count - 1])?.alpha = 1
    }
    
    func setForthCircle(){
        self.mapView.renderer(for: self.mapView.overlays[mapView.overlays.count - 2])?.alpha = 0
    }
    
    
    func getUserLocationLocation() -> CLLocation{
        let currentLocCoordinate: CLLocationCoordinate2D = mapView.userLocation.coordinate
        return CLLocation(latitude: currentLocCoordinate.latitude, longitude: currentLocCoordinate.longitude)
    }
    
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        //custom circle
        if overlay.isKind(of: MKCircle.self) {
            
            let circle = MKCircleRenderer(overlay: overlay)
            circle.fillColor = UIColor(white: 0.3, alpha: 0.3)
            return circle
          
        } else if overlay.isKind(of: MKPolyline.self) {

            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor(netHex: 0x007AFF)
            renderer.lineWidth = 5.0
            return renderer
        }
        
        return MKOverlayRenderer()
    }
    
    
    // set annotation
    func setRouteAnnotation(){
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(setAnnotation_Route))
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func setAnnotation_Route(gestureRecognizer: UITapGestureRecognizer){
        
        
        let touchLocation = gestureRecognizer.location(in: mapView)
        locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationCoordinate
        
        DispatchQueue.global().async {
            DispatchQueue.main.sync {
                //add annotation and route
                if self.mapView.annotations.count < 5 {
                    
                    //第一個
                    self.mapView.addAnnotation(annotation)
                    self.setRoute(locationCoordinate: self.locationCoordinate)
                    
                    self.setTimer_Route()
                    
                    print(self.mapView.annotations)
                    
                } else {

                    print(self.mapView.annotations)
                    
                    sleep(UInt32(0.5))
                    
                    //刪掉上一個
                    for obj in self.mapView.annotations{
                        if obj.isKind(of: MKPointAnnotation.self){
                            
                            self.mapView.removeAnnotation(obj)
                        }
                    }
                    
                    self.mapView.remove(self.mapView.overlays[0])

                    self.mapView.addAnnotation(annotation)
                    self.setRoute(locationCoordinate: self.locationCoordinate)
                    
                    self.setTimer_Route2()
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
        
        var annotationView: MKAnnotationView?
        
        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier){
            
            annotationView = dequeuedAnnotationView
            annotationView?.annotation = annotation
            annotationView?.canShowCallout = true
            
        } else {
            let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            av.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            annotationView = av
        }
        
    
        
        if let annotationView = annotationView, let _ = annotation as? AirDropAnnotation {
            annotationView.image = #imageLiteral(resourceName: "present")
        } else if let _ = annotation as? MKAnnotation{
            annotationView?.image = #imageLiteral(resourceName: "placeholder-1")
        }
        
        
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
    
    
    func eliminatedFromGame(){
        // create the alert
        let alert = UIAlertController(title: "您已被淘汰！", message: "原因：停留在非指定範圍的時間過長", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: UIAlertActionStyle.default, handler: { (action) in
            
            self.countForOut = 60.0
            GameStatus.sharedInstance.ifStarted = false
            
            self.gatherFigure {
                ApiService.sharedInstance.during_game_cancel(statsInfo: self.statsInfo, completion: {
                    EnterRoomStatus.sharedInstance.ifEnteredRoom = false
                    GameStatus.sharedInstance.ifStarted = false
                    self.dismiss(animated: true, completion: nil)
                })
            }
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    func gatherFigure(completion: () -> ()){
        statsInfo.total_distance = totalDistance.text
        statsInfo.total_time = "\(countForGame)"
        
        completion()
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
    
    func setTimer_Circle(){
        
        timerForCircle = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startShrinking), userInfo: nil, repeats: true)
    }
    
    func setTimer_DistanceToCircle(){
        
        timerForDistanceToCircle = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startTracking), userInfo: nil, repeats: true)
    }
    
    func setTimer_Out(){
        timerForOut = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(startTiming), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        
        let seconds = String(count)
        timerLabel.text = seconds
        count = count + 1
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
    
    @objc func startShrinking(){
        
        countForCircle = countForCircle - 1.0
        remainTime.text = "\(Int(Double(countForCircle / 60)))'\(Int(round(Double(countForCircle.truncatingRemainder(dividingBy: 60)))))''"
        
        if countForCircle == 0.0 && term == 0{
            //第一次縮圈
            countForCircle = 10.0
            term = 1
            setSecondCircle()
            
            //開始監控是否在圈外
            setTimer_DistanceToCircle()
            
        } else if countForCircle == 0.0 && term == 1 {
            //第二次縮圈
            countForCircle = 10.0
            term = 2
            setThirdCircle()
        } else if countForCircle == 0.0 && term == 2 {
            //第三次縮圈
            term = 3
            setForthCircle()
            timerForCircle.invalidate()
        }
    }
    
    @objc func startTracking(){
        
        let toCentre = getUserLocationLocation().distance(from: locations[term])

        var radius: CLLocationDistance = 0
        
        switch term {
        case 1:
            radius = 1500
        case 2:
            radius = 750
        case 3:
            radius = 100
        default:
            radius = 0
        }
        
        if toCentre - radius > 0 {

            countDownLbl.isHidden = false
            countDownView.isHidden = false
            
            distanceToCircle = toCentre - radius
            
            if !timerForOut.isValid && GameStatus.sharedInstance.ifStarted {
                //開始淘汰
                setTimer_Out()
            }
            
        } else {
        
            countDownLbl.isHidden = true
            countDownView.isHidden = true
            
            distanceToCircle = 0.0
            
            if timerForOut.isValid {
                //危機解除
                timerForOut.invalidate()
                countForOut = 20.0
            }
        }
        
        remainDistance.text = String(format: "%.2f", distanceToCircle / 1000)
    }
    
    @objc func startTiming(){
        
        countForOut = countForOut - 1.0
        countDownLbl.text = "\(Int(countForOut))"
        
        if countForOut == 0.0 {
            //出局
            timerForOut.invalidate()
            eliminatedFromGame()
        }
    }
}
