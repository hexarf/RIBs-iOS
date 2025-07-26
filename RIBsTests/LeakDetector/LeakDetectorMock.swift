//
//  LeakDetectorMock.swift
//  RIBs
//
//  Created by Alex Bush on 7/26/25.
//

@testable import RIBs
import Foundation
import RxSwift
import UIKit

final class LeakDetectionHandleMock: LeakDetectionHandle {
    var cancelCallCount = 0
    func cancel() {
        cancelCallCount += 1
    }
}

final class LeakDetectorMock: LeakDetector {
    
    var expectDeallocateCallCount = 0
    override func expectDeallocate(object: AnyObject, inTime time: TimeInterval) -> LeakDetectionHandle {
        expectDeallocateCallCount += 1
        return LeakDetectionHandleMock()
    }
    
    var expectViewControllerDisappearCallCount = 0
    override func expectViewControllerDisappear(viewController: UIViewController, inTime time: TimeInterval) -> LeakDetectionHandle {
        expectViewControllerDisappearCallCount += 1
        return LeakDetectionHandleMock()
    }
    
    var statusCallCount = 0
    override var status: Observable<LeakDetectionStatus> {
        statusCallCount += 1
        return super.status
    }
}
