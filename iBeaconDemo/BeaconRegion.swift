//
//  BeaconRegion.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/21/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import Foundation
import CoreLocation

typealias tRangeHandler = ([AnyObject]!) -> Void
typealias tStateHandler = (CLRegionState!) -> Void

class BeaconRegion: CLBeaconRegion {
    var rangeHandler: tRangeHandler?
    var stateHandler: tStateHandler?
    
    override init!(proximityUUID: NSUUID!, identifier: String!) {
        super.init(proximityUUID: proximityUUID, identifier: identifier)
        defaultValues()
    }
    
    override init!(proximityUUID: NSUUID!, major: CLBeaconMajorValue, identifier: String!) {
        super.init(proximityUUID: proximityUUID, major: major, identifier: identifier)
        defaultValues()
    }
    
    override init!(proximityUUID: NSUUID!, major: CLBeaconMajorValue, minor: CLBeaconMinorValue, identifier: String!) {
        super.init(proximityUUID: proximityUUID, major: major, minor: minor, identifier: identifier)
        defaultValues()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        defaultValues()
    }
    
    func defaultValues() {
        notifyEntryStateOnDisplay = true
        notifyOnEntry = true
        notifyOnExit = true
    }
}