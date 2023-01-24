import Foundation

struct User: Codable, Identifiable {
  let id: UUID
  let firstName: String?
  let lastName: String?
  
  var fullName: String {
    if let firstName, let lastName {
      return "\(firstName) \(lastName)".trimmingCharacters(in: .whitespacesAndNewlines)
    } else {
      return "unnamed"
    }
  }
}

