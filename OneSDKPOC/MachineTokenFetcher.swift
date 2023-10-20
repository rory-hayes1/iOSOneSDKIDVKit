import Foundation

class MachineTokenFetcher {
    
    func fetchMachineToken(completion: @escaping (Result<String, Error>) -> Void) {
        // Replace these variables with your actual values
        let CUSTOMER_ID = "12382455-81cc-32e1-1b06-8c7ea7c934e2"
        let CUSTOMER_CHILD_ID = "614c9fbd-6650-de32-4820-4194434af45e"
        let API_KEY = "25af7bf34a733a169767e2dcc23749f6faaae5d4aded7b1c76e67ed4ca529ef7040b18895484ef756de54d8443ac822536951d28ca41b5a99f7d5d771a3fcc47"
        
        // Create a JSON payload
        let jsonPayload = """
        {
            "permissions": {
                "preset": "one-sdk",
                "reference": "MTF"
            }
        }
        """
        
        // Construct the URL for the token endpoint
        let tokenUrl = URL(string: "https://backend.kycaml.uat.frankiefinancial.io/auth/v2/machine-session")!
        
        // Create and configure a URLRequest
        var request = URLRequest(url: tokenUrl)
        request.httpMethod = "POST"
        request.setValue("machine " + Data("\(CUSTOMER_ID):\(CUSTOMER_CHILD_ID):\(API_KEY)".utf8).base64EncodedString(), forHTTPHeaderField: "authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonPayload.data(using: .utf8)
        
        // Create a URLSession data task to send the request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data, let token = String(data: data, encoding: .utf8) {
                    completion(.success(token))
                } else {
                    completion(.failure(NSError(domain: "Token fetch error", code: 0, userInfo: nil)))
                }
            } else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(.failure(NSError(domain: "Token fetch error", code: statusCode, userInfo: nil)))
            }
        }
        
        task.resume()
    }
}
