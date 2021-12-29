import XCTest
import SwiftUI
@testable import SwiftBook
    
struct Doc: View {
    var body: some View {
        Text("Docuemnt Stub")
    }
}

final class SwiftBookTests: XCTestCase {
    func testInitEmpty() {
        let swiftbook = SwiftBook([])
        XCTAssert(swiftbook.documentsTable.count == 0)
    }
    
    func testInitWithDocuments() {
        let swiftbook = SwiftBook([("Doc", AnyView(Doc()))])
        XCTAssert(swiftbook.documentsTable.count == 1)
        XCTAssert(swiftbook.titles.count == 1)
    }
    
    func testInitTakeSnapshotIsFalse() {
        let swiftbook = SwiftBook([])
        XCTAssert(swiftbook.appModel.takeSnapshot == false)
    }
}
