//
//  InteractorTests.swift
//  RIBs
//
//  Created by Alex Bush on 6/22/25.
//

@testable import RIBs
import XCTest

final class InteractorTests: XCTestCase {
    
    private var interactor: InteractorMock!
    
    override func setUp() {
        super.setUp()
        
        interactor = InteractorMock() // NOTE: we're using InteractorMock here to test the underlying parent class, Interactor, behavior so this is appropriate here.
    }
    
    func test_interactorIsInactiveByDefault() {
        XCTAssertFalse(interactor.isActive)
        interactor.isActiveStream.subscribe { isActive in
            XCTAssertFalse(isActive)
        }
    }
    
    func test_isActive_whenStarted_isTrue() {
        // give
        // when
        interactor.activate()
        // then
        XCTAssertTrue(interactor.isActive)
        interactor.isActiveStream.subscribe { isActive in
            XCTAssertTrue(isActive)
        }
    }
    
    func test_isActive_whenDeactivated_isFalse() {
        // given
        interactor.activate()
        // when
        interactor.deactivate()
        // then
        XCTAssertFalse(interactor.isActive)
        interactor.isActiveStream.subscribe { isActive in
            XCTAssertFalse(isActive)
        }
    }
    
    func test_didBecomeActive_isCalledWhenStarted() {
        // given
        // when
        interactor.activate()
        // then
        XCTAssertEqual(interactor.didBecomeActiveCallCount, 1)
    }
    
    func test_didBecomeActive_isNotCalledWhenAlreadyActive() {
        // given
        interactor.activate()
        XCTAssertEqual(interactor.didBecomeActiveCallCount, 1)
        // when
        interactor.activate()
        // then
        XCTAssertEqual(interactor.didBecomeActiveCallCount, 1)
    }
    
    func test_willResignActive_isCalledWhenDeactivated() {
        // given
        interactor.activate()
        // when
        interactor.deactivate()
        // then
        XCTAssertEqual(interactor.willResignActiveCallCount, 1)
    }
    
    func test_willResignActive_isNotCalledWhenAlreadyInactive() {
        // given
        interactor.activate()
        interactor.deactivate()
        XCTAssertEqual(interactor.willResignActiveCallCount, 1)
        // when
        interactor.deactivate()
        // then
        XCTAssertEqual(interactor.willResignActiveCallCount, 1)
    }
    
    // MARK: - BEGIN Observables Attached to Interactor
    func test_isActiveStream_completedOnInteractorDeinit() {
        // given
        var isActiveStreamCompleted = false
        interactor.isActiveStream.subscribe { _ in
            
        } onError: { _ in
            
        } onCompleted: {
            isActiveStreamCompleted = true
        } onDisposed: {
            
        }
        // when
        interactor = nil
        // then
        XCTAssertTrue(isActiveStreamCompleted)
        
    }
    // MARK: Observables Attached to Interactor END -
}
