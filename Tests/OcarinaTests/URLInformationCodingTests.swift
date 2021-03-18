//
//  URLInformationCodingTests.swift
//  
//
//  Created by Benjamin Böcker on 18.03.21.
//

import Foundation

import XCTest
@testable import Ocarina

@available(iOS 11.0, *)
class URLInformationCodingTests: XCTestCase {

	func testStoreURLInfo() {
		guard let url = URL(string: "https://www.nytimes.com/interactive/2017/04/02/technology/uber-drivers-psychological-tricks.html") else {
			XCTFail("Invalid URL")
			return
		}
		
		let expectation = self.expectation(description: "The new york times article should have some basic information.")
		url.oca.fetchInformation { (information, error) in
			guard let urlInformation = information else {
				XCTFail()
				expectation.fulfill()
				return
			}

			do {
				let data = try NSKeyedArchiver.archivedData(withRootObject: urlInformation, requiringSecureCoding: true)
				
				do {
					let _ = try NSKeyedUnarchiver.unarchivedObject(ofClass: URLInformation.self, from: data as Data)
					expectation.fulfill()
				} catch {
					XCTFail("Failed to transform `Data` to `URLInformation`. \(error)")
					expectation.fulfill()
					return

				}
			} catch {
				XCTFail("Failed to transform `URLInformation` to `Data`. Error: \(error)")
				expectation.fulfill()
				return
			}
		}
		
		self.waitForExpectations(timeout: 10) { (error) in
			if let error = error {
				XCTFail("Expectation Failed with error: \(error)");
			}
		}
	}
}
