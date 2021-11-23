import Foundation

class NetworkRequest {
    static let shared = NetworkRequest()
    
    private init() {}
    
    func requestData(urlString: String, comletion: @escaping(Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                
                if let error = error {
                    comletion(.failure(error))
                    return
                }
                
                guard let data = data else { return }
                comletion(.success(data))
            }
        }
        .resume()
    }
}
