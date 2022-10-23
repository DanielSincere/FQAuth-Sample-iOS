import Foundation

struct CurrentAuthorization: Codable {
  let user: User
  let refreshToken: String
  let accessToken: String
}
