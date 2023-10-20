import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .blue
        
        // Attach the JavaScript interface
        let jsInterface = JavaScriptInterface(viewController: self)
        
        // Initialize WebView
        let configuration = WKWebViewConfiguration()
        configuration.allowsInlineMediaPlayback = true
        configuration.preferences.minimumFontSize = 40
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.upgradeKnownHostsToHTTPS = true
        configuration.userContentController.add(jsInterface, name: "Frankie1")
        configuration.websiteDataStore = .default()
        configuration.applicationNameForUserAgent = "Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.0 Mobile/15E148 Safari/604.1"
        
        webView = WKWebView(frame: view.bounds, configuration: configuration)
        webView.navigationDelegate = self
        webView.autoresizingMask = [.flexibleHeight]
        webView.uiDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        view.addSubview(webView)
        let machineTokenFetcher = MachineTokenFetcher()
        machineTokenFetcher.fetchMachineToken { result in
            switch result {
            case .success(let machineToken):
                // URL encode the machine token
                if let encodedMachineToken = machineToken.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                    // Use the URL-encoded token to construct the URL
                    if let url = URL(string: "https://192.168.1.105:5500/index.html?machinetoken=\(encodedMachineToken)") {
                        let request = URLRequest(url: url)
                        DispatchQueue.main.async {
                            self.webView.load(request)
                        }
                    }
                }
                
            case .failure(let error):
                // Handle the error, e.g., show an alert
                print("Error fetching machine token: \(error)")
            }
        }
        
        
        // Load the web page from a URL
//        if let url = URL(string: "https://192.168.1.105:5500/index.html") {
//            let request = URLRequest(url: url)
//            webView.load(request)
//         }
    
    }
}

extension WebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView didFinish navigation")
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debugPrint("WebView didFail navigation: \(error)")
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    private func requestMediaCapturePermission(for webView: WKWebView, origin: String, initiatedByFrame frame: WKFrameInfo?, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler()
        }))
        present(alertController, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, requestMediaCapturePermissionFor origin: WKSecurityOrigin, initiatedByFrame frame: WKFrameInfo, type: WKMediaCaptureType, decisionHandler: @escaping (WKPermissionDecision) -> Void) {
        decisionHandler(.grant)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        debugPrint(message)
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            completionHandler(true)
        }))
        present(alertController, animated: true, completion: nil)
        
    }
    
}
