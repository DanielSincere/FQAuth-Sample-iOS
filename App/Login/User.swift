import Foundation

struct User: Codable, Identifiable {
  let id: UUID
  let firstName: String
  let lastName: String
  
  var fullName: String {
    "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
  }
}
