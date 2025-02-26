import Foundation

protocol CallDelegate: AnyObject {
    func callDidConnect()
    func callDidDisconnect()
    func callDidFail(with error: Error)
} 