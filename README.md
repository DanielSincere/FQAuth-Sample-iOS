# FQAuth iOS

iOS SDK to interact with [FQAuth](https://github.com/FullQueueDeveloper/FQAuth) Server

## Goals

1. A sample app to show how Auth might work with [FQAuth](https://github.com/FullQueueDeveloper/FQAuth)
2. Reusable drop-in screens to get authentication working in your app.

## Local development setup

[Swish](https://github.com/FullQueueDeveloper/Swish) is a task runner to generate the `.xcodeproj` and other development tasks.

1. `brew bundle`
2. `swish generate`

The project is configured with the Bundle ID, Apple Development Team, and Server URL that you specify. These items can be specified in the shell environment, in a `.env` file, or using the `security` command line tool. The config first checks the environment, and then the `.env` file, and lastly, checks the `security` tool. Please see `.env.sample` for an example `.env` you can use. Instructions for using `security` are below.

- `FQAUTH_IOS_BUNDLE_ID` The bundle ID to use for the app.

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_BUNDLE_ID -w com.example.FQAuth-iOS
  ```

- `FQAUTH_IOS_DEVELOPMENT_TEAM` The development team to use

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_DEVELOPMENT_TEAM -w ASDF1234
  ```

- `FQAUTH_SERVER_URL` The server URL to use

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_SERVER_URL -w auth.example.com
  ```
