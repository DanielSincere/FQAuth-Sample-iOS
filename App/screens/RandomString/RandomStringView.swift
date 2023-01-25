import SwiftUI

struct RandomStringView: View {

  @ObservedObject
  var controller: RandomStringController = .init()

  var body: some View {
    VStack {

      SignOutButton()

      Group {
        switch controller.latestEvent.state {
        case .notLoaded:
          Text("not loaded")
            .foregroundColor(.gray)
        case .loading:
          ProgressView()
        case .loaded(let current):
          Text(current)
          HStack {
            RefreshButton(controller: controller)
            RegenerateButton(controller: controller)
          }
        case .error(let error):
          Text(error.localizedDescription)
            .foregroundColor(.red)
          RefreshButton(controller: controller)
        }
      }
      .task {
#if DEBUG
        guard !isPreview() else { return }
#endif

        await controller.refresh()
      }
    }
  }

  struct RefreshButton: View {
    @ObservedObject var controller: RandomStringController
    var body: some View {
      Button("refresh") {
        Task {
          await controller.refresh()
        }
      }
      .buttonStyle(.borderedProminent)
    }
  }

  struct RegenerateButton: View {
    @ObservedObject var controller: RandomStringController
    var body: some View {
      Button("Regenerate") {
        Task {
          await controller.regenerate()
        }
      }
      .buttonStyle(.bordered)
    }
  }
}



struct RandomStringView_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RandomStringView(controller: RandomStringController(state: .notLoaded))

      RandomStringView(controller: RandomStringController(state: .loading))

      RandomStringView(controller: RandomStringController(state: .error(RandomStringController.Errors.responseDataNotConvertibleToString)))

      RandomStringView(controller: RandomStringController(state: .loaded("yes it loads")))
    }
  }
}
