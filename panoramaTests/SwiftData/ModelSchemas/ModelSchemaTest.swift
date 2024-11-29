//
//  ModelSchemaTest.swift
//  panorama
//
//  Created by Noel Dupuis on 29/11/2024.
//

import XCTest
@testable import panorama

final class ModelSchemaTest: XCTestCase {
    
    typealias RecurringType = panorama.RecurringType
    
    func testRecurringTypeNextOccurenceFromDaily() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 11, day: 30)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.daily.nextOccurenceFrom(startDate: startDay, frequency: 1)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromDailyFreq2() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 12, day: 1)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.daily.nextOccurenceFrom(startDate: startDay, frequency: 2)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromDailyFreq30() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 12, day: 1)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.daily.nextOccurenceFrom(startDate: startDay, frequency: 30)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromWeekly() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 12, day: 6)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.weekly.nextOccurenceFrom(startDate: startDay, frequency: 1)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromWeeklyFreq2() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 12, day: 13)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.weekly.nextOccurenceFrom(startDate: startDay, frequency: 2)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromWeeklyFreq30() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2025, month: 5, day: 30)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.weekly.nextOccurenceFrom(startDate: startDay, frequency: 30)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromMonthly() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2024, month: 12, day: 29)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.monthly.nextOccurenceFrom(startDate: startDay, frequency: 1)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromMonthlyFreq2() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2025, month: 1, day: 29)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.monthly.nextOccurenceFrom(startDate: startDay, frequency: 2)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromMonthlyFreq30() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2027, month: 5, day: 1)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.monthly.nextOccurenceFrom(startDate: startDay, frequency: 30)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromYearly() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2025, month: 11, day: 29)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.yearly.nextOccurenceFrom(startDate: startDay, frequency: 1)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromYearlyFreq2() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 29)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2026, month: 11, day: 29)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.yearly.nextOccurenceFrom(startDate: startDay, frequency: 2)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
    
    func testRecurringTypeNextOccurenceFromYearlyFreq30() {
        let startDateComponents = DateComponents(year: 2024, month: 11, day: 1)
        let startDay = Calendar.current.date(from: startDateComponents)!
        
        let expectedDateComponents = DateComponents(year: 2054, month: 11, day: 1)
        let expectedNextOccurence = Calendar.current.date(from: expectedDateComponents)!
        
        let calculatedNextOccurence = RecurringType.yearly.nextOccurenceFrom(startDate: startDay, frequency: 30)
        
        XCTAssertEqual(calculatedNextOccurence, expectedNextOccurence)
    }
}
