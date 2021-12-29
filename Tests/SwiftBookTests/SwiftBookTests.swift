import XCTest
import SwiftUI
@testable import SwiftBook
    
struct TestDoc: View {
    var body: some View {
        Text("Docuemnt Stub")
    }
}

final class SwiftBookTests: XCTestCase {
    func testInitEmpty() {
        let swiftBook = SwiftBook([])
        XCTAssert(swiftBook.documentsTable.count == 0)
        XCTAssert(swiftBook.titles.count == 0)
    }
    
    func testInitWithDocuments() {
        let swiftBook = SwiftBook([
            ("Doc1", AnyView(TestDoc())),
            ("Doc2", AnyView(TestDoc())),
            ("Doc3", AnyView(TestDoc())),
        ])
        XCTAssert(swiftBook.documentsTable.count == 3)
        XCTAssert(swiftBook.titles.count == 3)
    }
    
    func testInitTakeSnapshotIsFalse() {
        let swiftBook = SwiftBook([])
        XCTAssert(swiftBook.appModel.takeSnapshot == false)
    }
}
