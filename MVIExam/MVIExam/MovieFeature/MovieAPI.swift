import Foundation

struct BoxOfficeResponse: Decodable {
    let boxOfficeResult: BoxOfficeResult
}

struct BoxOfficeResult: Decodable {
    let dailyBoxOfficeList: [BoxOfficeMovie]
}

struct BoxOfficeMovie: Decodable {
    let rnum: String
    let rank: String
    let movieNm: String
    let audiCnt: String
    let audiAcc: String
    let rankInten: String
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case decodingError
    
    var errorDescription: String? {
        switch self {
        case .invalidURL: return "잘못된 URL입니다."
        case .invalidResponse: return "서버 응답이 올바르지 않습니다."
        case .decodingError: return "데이터 변환에 실패했습니다."
        }
    }
}

actor MovieAPIService {
    private let baseURL = "http://www.kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json"
    private let apiKey = "63adcda43f0b97ae5d966b40878b62fb"
    
    func fetchMovies() async throws -> [Movie] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let targetDate = dateFormatter.string(from: yesterday)
        
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "targetDt", value: targetDate)
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let boxOffice = try JSONDecoder().decode(BoxOfficeResponse.self, from: data)
            return boxOffice.boxOfficeResult.dailyBoxOfficeList.map { movie in
                Movie(
                    id: movie.rnum,
                    rank: Int(movie.rank) ?? 0,
                    title: movie.movieNm,
                    audienceCount: Int(movie.audiCnt) ?? 0,
                    totalAudience: Int(movie.audiAcc) ?? 0,
                    rankIntensity: Int(movie.rankInten) ?? 0
                )
            }
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
} 