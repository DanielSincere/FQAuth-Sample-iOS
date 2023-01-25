import Foundation
import KeychainAccess

final class RandomStringController: ObservableObject {

  @Published var latestEvent: Event
  convenience init(state: Event.State) {
    self.init(event: Event(state: state))
  }

  init(event: Event = Event(state: .notLoaded)) {
    self.latestEvent = event
  }

  func refresh() async {
    do {

      let url = URL(string: "/api/sample", relativeTo: randomStringServerURL)!.absoluteURL
      let (data, _) = try await NetworkingHelper()
        .authorizedRequest(url: url)

      await MainActor.run {
        if let string = String(data: data, encoding: .utf8) {
          self.latestEvent = .init(state: .loaded(string))
        } else {
          self.latestEvent = .init(state: .error(Errors.responseDataNotConvertibleToString))
        }
      }
    } catch {
      self.latestEvent = .init(state: .error(Errors.urlSession(error)))
    }
  }

  func regenerate() async {

    do {
      let url = URL(string: "/api/sample/new", relativeTo: randomStringServerURL)!.absoluteURL
      let (data, response) = try await NetworkingHelper().authorizedRequest(url: url, httpMethod: "POST")

      await MainActor.run {
        if let string = String(data: data, encoding: .utf8) {
          self.latestEvent = .init(state: .loaded(string))
        } else {
          self.latestEvent = .init(state: .error(Errors.responseDataNotConvertibleToString))
        }
      }

    } catch {
      self.latestEvent = .init(state: .error(Errors.urlSession(error)))
    }
  }

  struct Event: Identifiable {
    let state: State
    let timestamp: Date = Date()

    var id: Date { timestamp }
    enum State {
      case notLoaded
      case loading
      case loaded(String)
      case error(Error)
    }
  }

  enum Errors: Error, LocalizedError {
    case responseDataNotConvertibleToString
    case urlSession(Error)
    case notLoggedIn

    var errorDescription: String? {
      switch self {
      case .notLoggedIn:
        return "Not logged in"
      case .responseDataNotConvertibleToString:
        return "Response data not convertible to string"
      case .urlSession(let error):
        return "URL Session error: " + error.localizedDescription
      }
    }
  }
}
