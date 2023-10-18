import Foundation
import JavaScriptCore
import WebKit

@objc protocol JavaScriptInterfaceProtocol: JSExport {
    func results(_ checkStatus: String, _ document: String, _ entityId: String)
    func inputRequired(_ entityId: String, _ checkStatus: String)
    func error(_ message: String, _ errorStatus: String)
    func detectionComplete(_ message: String)
}

class JavaScriptInterface: NSObject, JavaScriptInterfaceProtocol, WKScriptMessageHandler {
    
    weak var viewController: WebViewController?
    
    init(viewController: WebViewController) {
        super.init()
        self.viewController = viewController
    }
    
    func results(_ checkStatus: String, _ document: String, _ entityId: String) {
        print("--> onIDVResult")
    }
    
    func inputRequired(_ entityId: String, _ checkStatus: String) {
        print("--> onInputRequired")
    }
    
    func error(_ message: String, _ errorStatus: String) {
        print("--> onError")
    }
    
    func detectionComplete(_ message: String) {
        print("--> onDetectionComplete")
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("--> userContentController")
    }
}
