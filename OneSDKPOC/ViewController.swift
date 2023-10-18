import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .white
    }

    @IBAction func webViewBtnPressed(_ sender: Any) {
        let webVC = WebViewController()
        webVC.modalPresentationStyle = .fullScreen
        self.navigationController?.present(webVC, animated: true)
    }
    
}

