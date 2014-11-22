//
//  BeaconManager.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/21/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import Foundation
import CoreLocation
import CoreBluetooth

typealias tAutorizationStateHandler = (CLAuthorizationStatus!) -> Void

let sharedBeaconManager = BeaconManager()

class BeaconManager: NSObject, CLLocationManagerDelegate, CBCentralManagerDelegate {
    let locationManager = CLLocationManager()
    let bluetoothManager: CBCentralManager!
    var authorizationStateHandler: tAutorizationStateHandler?
    
    private(set) lazy var regions: [CLBeaconRegion] = { return [CLBeaconRegion]() }()
    
    class var sharedInstance:BeaconManager {
        return sharedBeaconManager
    }
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        bluetoothManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue(), options: [CBCentralManagerOptionShowPowerAlertKey: true])
        
        if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") == nil {
            fatalError("Please add NSLocationAlwaysUsageDescription to your Info.plist file")
        }
    }
    
    func startMonitoringRegion(region: BeaconRegion) {
        if find(regions, region) == nil {
            regions.append(region)
            locationManager.startMonitoringForRegion(region)
        } else {
            locationManager.requestStateForRegion(region)
        }
    }
    
    func stopMonitoringRegion(region: BeaconRegion) {
        if let index = find(regions, region) {
            locationManager.stopMonitoringForRegion(region)
            regions.removeAtIndex(index)
        }
    }
    
    func findBeaconRegion(region: CLRegion) -> BeaconRegion? {
        for beaconRegion in regions {
            if beaconRegion is BeaconRegion && equal(beaconRegion.identifier, region.identifier) {
                return beaconRegion as? BeaconRegion
            }
        }
        
        return nil
    }
    
    // CBCentralManagerDelegate
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        switch bluetoothManager.state {
            case .PoweredOn:
                for region in regions {
                    locationManager.requestStateForRegion(region)
                }
            default:
                for region in regions {
                    locationManager.stopRangingBeaconsInRegion(region)
                }
        }
    }
    
    // CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .Authorized {
            for region in regions {
                locationManager.requestStateForRegion(region)
            }
        }
        
        authorizationStateHandler?(status)
    }
    
    func locationManager(manager: CLLocationManager!, didStartMonitoringForRegion region: CLRegion!) {
        println("didStartMonitoringForRegion \(region)")
        
        locationManager.requestStateForRegion(region)
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        println("didEnterRegion \(region)")
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        println("didExitRegion \(region)")
    }
    
    func locationManager(manager: CLLocationManager!, didDetermineState state: CLRegionState, forRegion region: CLRegion!) {
        if let beaconRegion = findBeaconRegion(region) {
            switch state {
                case .Inside:
                    println("Inside \(region)")
                    locationManager.startRangingBeaconsInRegion(beaconRegion)
                    beaconRegion.stateHandler?(.Inside)
                case .Outside:
                    println("Outside \(region)")
                    locationManager.stopRangingBeaconsInRegion(beaconRegion)
                    beaconRegion.stateHandler?(.Outside)
                case .Unknown:
                    println("Unknown \(region)")
                    beaconRegion.stateHandler?(.Unknown)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        println("[INFO] didRangeBeacons region: \(region)")

        if let beaconRegion = findBeaconRegion(region) {
            beaconRegion.rangeHandler?(beacons)
        }
        
        for beacon in beacons {
            println("Beacon: \(beacon)")
        }
    }
    
    func locationManager(manager: CLLocationManager!, monitoringDidFailForRegion region: CLRegion!, withError error: NSError!) {
        println("[ERROR] monitoringDidFailForRegion \(region): \(error)")
    }
    
    func locationManager(manager: CLLocationManager!, rangingBeaconsDidFailForRegion region: CLBeaconRegion!, withError error: NSError!) {
        println("[ERROR] rangingBeaconsDidFailForRegion \(region): \(error)")
    }
}