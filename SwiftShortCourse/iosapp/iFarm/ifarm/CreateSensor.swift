//
//  CreateSensor.swift
//  iFarm
//
//  Created by Tuuu on 9/2/16.
//  Copyright © 2016 Techmaster Vietnam. All rights reserved.
//

import UIKit
import MapKit
class CreateSensor: BaseViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    var lbl_SensorID: UILabel!
    var tv_SensorID: TextViewCornerRadius!
    var lbl_Cordinate: UILabel!
    var btn_GetCurrentLocation: UIButton!
    var tv_Latitute: TextViewCornerRadius!
    var tv_Longitute: TextViewCornerRadius!
    var lbl_Description: UILabel!
    var tv_Description: TextViewCornerRadius!
    var btn_CreateSensor: ButtonLogin!
    var btn_GetSensorsAround: UIButton!
    //Map
    var mapView: MKMapView!
    var fromLocation: CLLocation? // lưu toạ độ của một địa điểm với độ chính xác cao.
    let locationManager = CLLocationManager()//NSLocationWhenInUseUsageDescription
    //class này là một lớp rất quan trọng cung cấp các tham số để cấu hình phục vụ cho việc cập nhật toạ độ người dùng...
    
    var farmSelected : Farm?
    
    //----------------------------------------------------------------------------------------
    var overlay : MKOverlay? //-- bien ve~ doan duong
    var direction:MKDirections? //-- lay ra tuyen duong di
    var foundPlace :CLPlacemark? //-- luu cac bien ten duong, quan ,huyen
    var geoCoder : CLGeocoder! //-- adapter chuyen doi
    
    //--- khoi tao frame cho custom MKAnnotation ---------------------------------------------
    var kWidthDetailCallout : CGFloat = 200
    var kHeightDetailCallout  : CGFloat = 80
    var mkAnnotaionView:MKAnnotationView!
    var annotation:LocationAnnotation?
    var annotations: [LocationAnnotation] = [LocationAnnotation]()
    //----------------------------------------------------------------------------------------
    
    var sensorsAround = [Sensor]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContraints()
        getSensorWithFarmID()
        
        
        //-- khoi tao clgeocoder
        self.geoCoder = CLGeocoder()
        self.edgesForExtendedLayout = .None
        
        self.mapView.delegate = self
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest //thông tin chính xác về địa điểm người dùng càng chi tiết thì càng tốn tài nguyên của máy bạn
        self.locationManager.requestWhenInUseAuthorization()
        
        navigationItem.title = farmSelected?.title
    }
    
    func getSensorWithFarmID(){
        
        activeActivityIndicator()
        Router.shareInstance.getSensorWithFarmID((farmSelected?.id)!, success: { (arraySensor) in
            
            for sensorWithAxes in arraySensor as! [Sensor] {
                
                if sensorWithAxes.latitude != nil && sensorWithAxes.longitude != nil{
                    self.sensorsAround.append(sensorWithAxes)
                }
            }
            
            self.deActiveIndicator()
            
        }) { (error) in
            self.deActiveIndicator()
        }
    }
    
    func action_Add()
    {
        var params = [String : AnyObject]()
        
        params = ["farmId": (farmSelected?.id)!]
        
        if tv_SensorID.text != "" {
            params["id"] = tv_SensorID.text
            
            if tv_Longitute.text != "" && tv_Latitute.text != "" {
                params["longitude"] = Float(tv_Longitute.text)
                params["latitude"] = Float(tv_Latitute.text)
            }
            
            if tv_Description.text != "" {
                params["description"] = tv_Description.text
            }
            
            activeActivityIndicator()
            
            router.createSensor(params, success: { (data) in
                self.deActiveIndicator()
                self.navigationController?.popViewControllerAnimated(true)
                }, failed: { (error) in
                    self.alertView("Warning", message: error!.localizedDescription, titleAction: "Ok", completionHandle: nil)
                    self.deActiveIndicator()
            })
            
        }else{
            alertView("Warning", message: "Bạn cần nhập SensorID", titleAction: "Ok", completionHandle: nil)
        }
        
    }
    
    func getSensorsARoundLocation()
        
    {
        print(self.sensorsAround.count)
        //--c2
        if(annotations.count == 0){
            //-- chua add du lieu lan nao
            
            annotations = sensorsAround.map { location -> LocationAnnotation in
                
                
                let annotation = LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude:Double(location.latitude!),longitude: Double(location.longitude!)), title:String( UTF8String: location.id)!)
                print(self.sensorsAround.count)
                
                return annotation
            }
            
            mapView.addAnnotations(annotations)
            
            
        }else{
            mapView.removeAnnotations(annotations)
            annotations = sensorsAround.map { location -> LocationAnnotation in
                
                
                
                let annotation = LocationAnnotation(coordinate: CLLocationCoordinate2D(latitude:Double(location.latitude!),longitude: Double(location.longitude!)), title: location.id)
                
                return annotation
            }
            
            mapView.addAnnotations(annotations)
            
        }
        
        
    }
    
    
    
    func getCurrentLocation()
    {
        self.locationManager.startUpdatingLocation()
        
    }
    
    func addAnnotaion(coordinate: CLLocationCoordinate2D, title: String, imageName: String)
    {
        if(annotation == nil){
            
            annotation = LocationAnnotation(coordinate: coordinate,
                                            title: title,
                                            image: imageName)
            
            
            self.mapView.addAnnotation(annotation!)
        }
        else{
            
            mapView.removeAnnotation(annotation!)
            annotation = LocationAnnotation(coordinate: coordinate,
                                            title: title,
                                            image: imageName)
            
            
            self.mapView.addAnnotation(annotation!)
        }
    }
    
    // MARK: - Location Delegate Methods
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        self.locationManager.stopUpdatingLocation()
        let location = locations.last
        //set cordinate for textview
        self.tv_Latitute.text = String(location!.coordinate.latitude)
        self.tv_Longitute.text = String(location!.coordinate.longitude)
        self.fromLocation = location
        self.updateRegion(2.0)
        
        //add annotation
        addAnnotaion(location!.coordinate, title: "Techmaster", imageName: "green")
    }
    func updateRegion(scale: Float) {
        let size: CGSize = self.mapView.bounds.size
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(fromLocation!.coordinate, Double(Float(size.height) * scale), Double(Float(size.width) * scale))
        self.mapView.setRegion(region, animated: true)
    }
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError)
    {
        print("Error: " + error.localizedDescription)
    }
    func mapSetRegion(fromPoint: CLLocationCoordinate2D, and toPoint: CLLocationCoordinate2D) {
        let centerPoint: CLLocationCoordinate2D = CLLocationCoordinate2DMake((fromPoint.latitude + toPoint.latitude) / 2.0, (fromPoint.longitude + toPoint.longitude) / 2.0)
        let latitudeDelta: Double = abs(fromPoint.latitude - toPoint.latitude) * 1.5
        let longtitudeDelta: Double = abs(fromPoint.longitude - toPoint.longitude) * 1.5
        let span: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longtitudeDelta)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(centerPoint, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier: String = "Pin"
        
        var mkAnnotaionView = self.mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        
        
        if mkAnnotaionView == nil{
            
            mkAnnotaionView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
        }
        
        
        if let annotation = annotation as? LocationAnnotation
        {
            
            
            if (annotation.title == "Techmaster")
            {
                
                
                mkAnnotaionView?.annotation = annotation
                
                //-- khoi tao view
                let viewDetail = DetailCalloutView(frame: CGRectMake(0,0,kWidthDetailCallout,100))
                viewDetail.setLabelName(CGRectMake(0, 0, kWidthDetailCallout, 30), text: "TechMaster", textAlignment: .Center, fontSize: 22)
                viewDetail.setImage(CGRectMake(0, 30, kWidthDetailCallout, 70), image: UIImage(named:"logo-1" )!, contenMode: .ScaleAspectFill)
                
                mkAnnotaionView?.detailCalloutAccessoryView = viewDetail
                mkAnnotaionView?.calloutOffset = CGPoint(x: 0, y: 4) //-- set vi tri show
                mkAnnotaionView?.image = UIImage(named:"logo-1")
                
            }
            else
            {
                
                let pinView: MKPinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pinView.pinTintColor = UIColor.blueColor()
                
                //-- hien thi vi tri pinview -- touch user
                
                pinView.calloutOffset = CGPoint(x: -15 , y: -5)
                pinView.contentMode = .Center
                
                
                //-- custom button right location
                let rightButton:UIButton = UIButton(frame: CGRectMake(0 , 0, 40, 40))
                rightButton.setBackgroundImage(UIImage(named: "getCurrentLocation"), forState: .Normal)
                pinView.rightCalloutAccessoryView = rightButton
                
                
                //-- custom detailCallView
                let detailCallout = DetailCalloutView(frame: CGRectMake(0, 0, kWidthDetailCallout, kHeightDetailCallout))//-- khoi tao view
                
                //-- load sensor trong mang
                
                for sensor in sensorsAround {
                    if sensor.id == annotation.title {
                        if let temp = sensor.sensorData?.temperature {
                            detailCallout.setLabelName(CGRectMake(0, 0, kWidthDetailCallout, 17),text: "Nhiệt độ: \(temp)" ,textAlignment: .Left,fontSize:15 )
                        }
                        if let pH = sensor.sensorData?.pH {
                            detailCallout.setLabelName(CGRectMake(0, 17, kWidthDetailCallout, 17), text: "Độ pH: \(pH)"  , textAlignment: .Left,fontSize:15 )
                        }
                        if let pin = sensor.sensorData?.battery {
                            detailCallout.setLabelName(CGRectMake(0, 34, kWidthDetailCallout, 17), text: "Pin: \(pin)"  ,textAlignment: .Left,fontSize:15 )
                        }
                        if let moisture = sensor.sensorData?.moisture {
                            detailCallout.setLabelName(CGRectMake(0, 51, kWidthDetailCallout, 17), text: "Độ ẩm: \(moisture)"  ,textAlignment: .Left,fontSize:15 )
                        }
                    }
                }
                
                
                pinView.detailCalloutAccessoryView = detailCallout
                mkAnnotaionView = pinView
                
                
            }
            
            mkAnnotaionView?.canShowCallout = true
        }
        
        return mkAnnotaionView
    }
    
    
    //-- check user tap rightbutton
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        //-- check
        if (control == view.rightCalloutAccessoryView){
            
            var latitude:Double
            var longitude:Double
            //-- check xem da ve~ duong chua
            if(overlay != nil){
                self.mapView.removeOverlay(overlay!)
            }
            for sensor in sensorsAround{
                print(view.annotation?.title)
                if(sensor.id == (view.annotation?.title)!){
                    latitude = Double(sensor.latitude!)
                    longitude = Double(sensor.longitude!)
                    lookForAddress(latitude, longitute: longitude)
                    
                }
            }
            
            
            mapView.deselectAnnotation(view.annotation, animated: true) //-- hidden view
        }
    }
    
    
    //-- add subview in mapview show when user didselection
    
    func mapView(mapView: MKMapView, didSelectAnnotationView view: MKAnnotationView) {
        
        mkAnnotaionView = MKAnnotationView(annotation: view.annotation, reuseIdentifier: "Pin")
        view.addSubview(mkAnnotaionView)
    }
    
    
    
    //-- remove subview
    
    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
        
        mkAnnotaionView.removeFromSuperview()
    }
    
    
    //-- tim vi tri
    
    func lookForAddress(latitude: Double, longitute: Double){
        let toPlace = CLLocation(latitude: latitude, longitude: longitute)
        self.routePath(MKPlacemark(coordinate: self.fromLocation!.coordinate, addressDictionary: nil),toLocation: MKPlacemark(coordinate: toPlace.coordinate, addressDictionary: nil))
        
    }
    
    
    //-- func routePath -- ve duong di
    func routePath(fromPlace : MKPlacemark, toLocation : MKPlacemark){
        let request = MKDirectionsRequest() //-- khoi tao
        let fromMapItem  = MKMapItem(placemark: fromPlace)
        request.source = fromMapItem
        let toMapItem = MKMapItem(placemark: toLocation)
        request.destination = toMapItem
        
        self.direction = MKDirections(request: request)
        self.direction!.calculateDirectionsWithCompletionHandler { (response, error) in
            if(error == nil){
                self.showRoute(response!)
            }
        }
    }
    
    //-- show len response -- tra ve chi tiet cac duong di de ve
    func showRoute(response : MKDirectionsResponse){
        //-- tra ve 1 mang
        for route in response.routes{
            self.overlay = route.polyline
            self.mapView.addOverlay(overlay!, level: .AboveRoads)
            for step in route.steps{
                
                print(step.instructions)
            }
        }
        
        
    }
    
    //--render -- ve duong line
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = UIColor.blueColor()
        render.lineWidth = 3.0
        
        return render
        
    }
    
    
    //addContraint
    func addContraints()
    {
        //lbl_name
        self.lbl_SensorID = UILabel(frame: CGRectMake(100, 160, 100, 100))
        self.lbl_SensorID.text = "SensorID"
        self.lbl_SensorID.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lbl_SensorID)
        var layoutY = NSLayoutConstraint(item: lbl_SensorID, attribute: .Top, relatedBy: .Equal, toItem: self.topLayoutGuide, attribute: .Bottom, multiplier: 1.0, constant: 8)
        var layoutHeight = NSLayoutConstraint(item: lbl_SensorID, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 20)
        var layoutX = NSLayoutConstraint(item: lbl_SensorID, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: 8)
        var layoutWidth = NSLayoutConstraint(item: lbl_SensorID, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //tv_name
        self.tv_SensorID = TextViewCornerRadius(frame: CGRectMake(100, 160, 100, 100))
        self.tv_SensorID.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_SensorID)
        layoutY = NSLayoutConstraint(item: tv_SensorID, attribute: .Top, relatedBy: .Equal, toItem: self.lbl_SensorID, attribute: .Bottom, multiplier: 1.0, constant: 4)
        layoutHeight = NSLayoutConstraint(item: tv_SensorID, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35)
        layoutX = NSLayoutConstraint(item: tv_SensorID, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: tv_SensorID, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //lbl_Cordinate
        self.lbl_Cordinate = UILabel(frame: CGRectMake(100, 160, 100, 100))
        self.lbl_Cordinate.text = "Toạ độ"
        self.lbl_Cordinate.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lbl_Cordinate)
        layoutY = NSLayoutConstraint(item: lbl_Cordinate, attribute: .Top, relatedBy: .Equal, toItem: self.tv_SensorID, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: lbl_Cordinate, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        layoutX = NSLayoutConstraint(item: lbl_Cordinate, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        layoutWidth = NSLayoutConstraint(item: lbl_Cordinate, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 0)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //btn_GetCurrentLocation
        
        self.btn_GetCurrentLocation = UIButton(frame: CGRectMake(100, 300, 100, 100))
        self.btn_GetCurrentLocation.setImage(UIImage(named: "getCurrentLocation"), forState: .Normal)
        self.btn_GetCurrentLocation.addTarget(self, action: #selector(getCurrentLocation), forControlEvents: .TouchUpInside)
        self.btn_GetCurrentLocation.setTitle("Lấy vị trí", forState: .Normal)
        self.btn_GetCurrentLocation.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.btn_GetCurrentLocation)
        
        layoutY = NSLayoutConstraint(item: btn_GetCurrentLocation, attribute: .Top, relatedBy: .Equal, toItem: self.tv_SensorID, attribute: .Bottom, multiplier: 1.0, constant: 4)
        layoutHeight = NSLayoutConstraint(item: btn_GetCurrentLocation, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        layoutX = NSLayoutConstraint(item: btn_GetCurrentLocation, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: btn_GetCurrentLocation, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //tv_Latitute
        self.tv_Latitute = TextViewCornerRadius(frame: CGRectMake(100, 1000, 100, 100))
        self.tv_Latitute.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_Latitute)
        layoutY = NSLayoutConstraint(item: tv_Latitute, attribute: .Top, relatedBy: .Equal, toItem: self.lbl_Cordinate, attribute: .Bottom, multiplier: 1.0, constant: 4)
        layoutHeight = NSLayoutConstraint(item: tv_Latitute, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35)
        layoutX = NSLayoutConstraint(item: tv_Latitute, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        layoutWidth = NSLayoutConstraint(item: tv_Latitute, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: -8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //tv_Longitute
        self.tv_Longitute = TextViewCornerRadius(frame: CGRectMake(100, 1000, 100, 100))
        self.tv_Longitute.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_Longitute)
        layoutY = NSLayoutConstraint(item: tv_Longitute, attribute: .Top, relatedBy: .Equal, toItem: self.btn_GetCurrentLocation, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: tv_Longitute, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 35)
        layoutX = NSLayoutConstraint(item: tv_Longitute, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1.0, constant: 4)
        layoutWidth = NSLayoutConstraint(item: tv_Longitute, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //lbl_description
        self.lbl_Description = UILabel(frame: CGRectMake(100, 160, 100, 100))
        self.lbl_Description.text = "Miêu tả"
        self.lbl_Description.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.lbl_Description)
        layoutY = NSLayoutConstraint(item: lbl_Description, attribute: .Top, relatedBy: .Equal, toItem: self.tv_Latitute, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: lbl_Description, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 30)
        layoutX = NSLayoutConstraint(item: lbl_Description, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -8)
        layoutWidth = NSLayoutConstraint(item: lbl_Description, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 8)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //tv_description
        self.tv_Description = TextViewCornerRadius(frame: CGRectMake(100, 1000, 100, 100))
        self.tv_Description.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.tv_Description)
        layoutY = NSLayoutConstraint(item: tv_Description, attribute: .Top, relatedBy: .Equal, toItem: self.lbl_Description, attribute: .Bottom, multiplier: 1.0, constant: 4)
        layoutHeight = NSLayoutConstraint(item: tv_Description, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 100)
        layoutX = NSLayoutConstraint(item: tv_Description, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: tv_Description, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        //btn_add
        
        self.btn_CreateSensor = ButtonLogin(frame: CGRectMake(100, 300, 100, 100))
        self.btn_CreateSensor.addTarget(self, action: #selector(action_Add), forControlEvents: .TouchUpInside)
        self.btn_CreateSensor.setTitle("Tạo Sensor", forState: .Normal)
        self.btn_CreateSensor.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.btn_CreateSensor)
        
        layoutY = NSLayoutConstraint(item: btn_CreateSensor, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: -35)
        layoutHeight = NSLayoutConstraint(item: btn_CreateSensor, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 40)
        layoutX = NSLayoutConstraint(item: btn_CreateSensor, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -30)
        layoutWidth = NSLayoutConstraint(item: btn_CreateSensor, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 30)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //mapkit
        self.mapView = MKMapView(frame: CGRectMake(0, 0, 100, 100))
        self.mapView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.mapView)
        layoutY = NSLayoutConstraint(item: mapView, attribute: .Top, relatedBy: .Equal, toItem: self.tv_Description, attribute: .Bottom, multiplier: 1.0, constant: 8)
        layoutHeight = NSLayoutConstraint(item: mapView, attribute: .Bottom, relatedBy: .Equal, toItem: self.btn_CreateSensor, attribute: .Top, multiplier: 1.0, constant: -20)
        layoutX = NSLayoutConstraint(item: mapView, attribute: .Trailing, relatedBy: .Equal, toItem: self.view, attribute: .Trailing, multiplier: 1.0, constant: -16)
        layoutWidth = NSLayoutConstraint(item: mapView, attribute: .Leading, relatedBy: .Equal, toItem: self.view, attribute: .Leading, multiplier: 1.0, constant: 16)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
        //btn_GetSensorsAround
        self.btn_GetSensorsAround = UIButton(frame: CGRectMake(100, 300, 100, 100))
        self.btn_GetSensorsAround.setImage(UIImage(named: "getSensorARound"), forState: .Normal)
        self.btn_GetSensorsAround.addTarget(self, action: #selector(getSensorsARoundLocation), forControlEvents: .TouchUpInside)
        self.btn_GetSensorsAround.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.btn_GetSensorsAround)
        
        layoutY = NSLayoutConstraint(item: btn_GetSensorsAround, attribute: .Bottom, relatedBy: .Equal, toItem: self.mapView, attribute: .Bottom, multiplier: 1.0, constant: 0)
        layoutHeight = NSLayoutConstraint(item: btn_GetSensorsAround, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
        layoutX = NSLayoutConstraint(item: btn_GetSensorsAround, attribute: .Trailing, relatedBy: .Equal, toItem: self.mapView, attribute: .Trailing, multiplier: 1.0, constant: 0)
        layoutWidth = NSLayoutConstraint(item: btn_GetSensorsAround, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50)
        NSLayoutConstraint.activateConstraints([layoutX, layoutY, layoutWidth, layoutHeight])
        
    }
}
