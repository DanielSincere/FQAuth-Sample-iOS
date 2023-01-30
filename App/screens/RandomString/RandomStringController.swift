import Foundation

final class RandomStringController: ObservableObject {

  let networking: FQNetworking

  @Published var latestEvent: Event
  convenience init(state: Event.State, networking: FQNetworking) {
    self.init(event: Event(state: state), networking: networking)
  }

  init(event: Event = Event(state: .notLoaded), networking: FQNetworking) {
    self.latestEvent = event
    self.networking = networking
  }

  func refresh() async {
    do {

      let url = URL(string: "/api/sample", relativeTo: randomStringServerURL)!.absoluteURL
      let (data, _) = try await networking
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
      let (data, _) = try await networking
        .authorizedRequest(url: url, httpMethod: "POST")

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
