//
//  BeaconExtensions.swift
//  iBeaconDemo
//
//  Created by Fedya Skitsko on 11/22/14.
//  Copyright (c) 2014 LabWerk. All rights reserved.
//

import Foundation
import CoreLocation

extension CLRegionState {
    func toString() -> String {
        switch self {
        case .Inside:
            return "Inside"
        case .Outside:
            return "Outside"
        case .Unknown:
            return "Unknown"
        }
    }
}