import Flutter
import UIKit
import AVFoundation
import CoreLocation
import Contacts

public class SwiftSimplePermissionsPlugin: NSObject, FlutterPlugin, CLLocationManagerDelegate {
    var whenInUse = false;
    var result: FlutterResult? = nil;
    var locationManager = CLLocationManager()
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "simple_permissions", binaryMessenger: registrar.messenger())
        let instance = SwiftSimplePermissionsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        locationManager.delegate = self;
        let method = call.method;
        let dic = call.arguments as? [String: Any];
        switch(method) {
        case "checkPermission":
            let permission = dic!["permission"] as! String;
            checkPermission(permission, result: result);
            break;
        case "getPermissionStatus":
            let permission = dic!["permission"] as! String
            getPermissionStatus(permission, result: result)
            break
        case "requestPermission":
            let permission = dic!["permission"] as! String;
            requestPermission(permission, result: result);
            break;
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
            break;
        case "openSettings":
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                if UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        result(true);
                    } else {
                        // Fallback on earlier versions
                        result(FlutterMethodNotImplemented);
                    }
                }
            }
            break;
        default:
            result(FlutterMethodNotImplemented);
            break;
        }
        
    }
    
    // Request permission
    private func requestPermission(_ permission: String, result: @escaping FlutterResult) {
        switch(permission) {
        case "RECORD_AUDIO":
            requestAudioPermission(result: result);
            break;
        case "CAMERA":
            requestCameraPermission(result: result);
            break;
case "ACCESS_COARSE_LOCATION", "ACCESS_FINE_LOCATION", "WHEN_IN_USE_LOCATION":
            self.result = result;
            requestLocationWhenInUsePermission();
            break;
        case "ALWAYS_LOCATION":
            self.result = result;
            requestLocationAlwaysPermission();
            break;
        case "READ_CONTACTS", "WRITE_CONTACTS":
            requestContactPermission(result: result)
            break;
        default:
            result(FlutterMethodNotImplemented);
            break;
        }
    }
    
    // Check permissions
    private func checkPermission(_ permission: String, result: @escaping FlutterResult) {
        switch(permission) {
        case "RECORD_AUDIO":
            result(checkAudioPermission());
            break;
        case "CAMERA":
            result(checkCameraPermission());
            break;
        case "ACCESS_COARSE_LOCATION", "ACCESS_FINE_LOCATION", "WHEN_IN_USE_LOCATION":
            result(checkLocationWhenInUsePermission());
            break;
        case "READ_CONTACTS", "WRITE_CONTACTS":
            result(checkContactPermission())
            break;
        case "ALWAYS_LOCATION":
            result(checkLocationAlwaysPermission());
            break;
        default:
            result(FlutterMethodNotImplemented);
            break;
        }
    }
    
    // Get permissions status
    private func getPermissionStatus (_ permission: String, result: @escaping FlutterResult) {
        switch(permission) {
        case "RECORD_AUDIO":
            result(getAudioPermissionStatus().rawValue)
            break;
        case "READ_CONTACTS", "WRITE_CONTACTS":
            result(getContactPermissionStatus().rawValue)
            break;
        case "CAMERA":
            result(getCameraPermissionStatus().rawValue)
            break;
        case "ACCESS_COARSE_LOCATION", "ACCESS_FINE_LOCATION", "WHEN_IN_USE_LOCATION":
            let status = CLLocationManager.authorizationStatus()
            if (status == .authorizedAlways || status == .authorizedWhenInUse) {
                 result(3)
            }
            else {
                result(status.rawValue)
            }
            break;
        case "ALWAYS_LOCATION":
            let status = CLLocationManager.authorizationStatus()
            if (status == .authorizedAlways) {
                result(3)
            }
            else if (status == .authorizedWhenInUse) {
                result(1)
            }
            else {
                result(status.rawValue)
            }
            break;
        default:
            result(FlutterMethodNotImplemented);
            break;
        }
    }
    
    //-----------------------------------------
    // Location
    private func checkLocationAlwaysPermission() -> Bool {
        return CLLocationManager.authorizationStatus() == .authorizedAlways;
    }
    
    private func checkLocationWhenInUsePermission() -> Bool {
        let authStatus = CLLocationManager.authorizationStatus();
        return  authStatus == .authorizedAlways  || authStatus == .authorizedWhenInUse;
    }
    
    private func requestLocationWhenInUsePermission() -> Void {
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
            self.whenInUse = true;
            locationManager.requestWhenInUseAuthorization();
        }
        else  {
            self.result!(checkLocationWhenInUsePermission());
        }
    }
    
    private func requestLocationAlwaysPermission() -> Void {
        if (CLLocationManager.authorizationStatus() == .notDetermined) {
        self.whenInUse = false;
        locationManager.requestAlwaysAuthorization();
        }
        else  {
            self.result!(checkLocationAlwaysPermission());
        }
    }
    
    public func locationManager(_ manager: CLLocationManager,
                         didChangeAuthorization status: CLAuthorizationStatus) {
        if (whenInUse)  {
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                self.result!(true);
                break;
            default:
                self.result!(false);
                break;
            }
        }
        else {
            self.result!(status == .authorizedAlways)
        }
    }
    
    //-----------------------------
    // Contact
    
    private func getContactPermissionStatus() -> CNAuthorizationStatus {
       return CNContactStore.authorizationStatus(for: CNEntityType.contacts)
    }
    
    private func checkContactPermission() -> Bool {
        return getContactPermissionStatus() == .authorized
    }
    
    private func requestContactPermission(result: @escaping FlutterResult) -> Void {
        CNContactStore().requestAccess(for: CNEntityType.contacts) { (access, error) in
            result(access)
        }
    }
    
    //---------------------------------
    // Audio
    private func checkAudioPermission() -> Bool {
        return getAudioPermissionStatus() == .authorized;
    }
    
    private func getAudioPermissionStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.audio);
    }
    
    private func requestAudioPermission(result: @escaping FlutterResult) -> Void {
        if (AVAudioSession.sharedInstance().responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({granted in
                result(granted);
            })
        }
    }
    
    //-----------------------------------
    // Camera
    private func checkCameraPermission()-> Bool {
      return getCameraPermissionStatus() == .authorized;
    }
    
    private func getCameraPermissionStatus() -> AVAuthorizationStatus {
        return AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
    }
    
    
    private func requestCameraPermission(result: @escaping FlutterResult) -> Void {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            result(response);
        }
    }
}
