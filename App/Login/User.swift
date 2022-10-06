import Foundation

struct User: Codable, Identifiable {
  let id: UUID
  let name: String
  let accessToken: String
  let refreshToken: String
}
