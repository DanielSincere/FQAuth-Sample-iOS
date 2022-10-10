# FQAuth iOS

iOS SDK to interact with [FQAuth](https://github.com/FullQueueDeveloper/FQAuth) Server

## Goals

1. A sample app to show how Auth might work with [FQAuth](https://github.com/FullQueueDeveloper/FQAuth)
2. Reusable drop-in screens to get authentication working in your app.

## Local development setup

Install [Mint](https://github.com/yonaskolb/Mint) and use [Swish](https://github.com/FullQueueDeveloper/Swish) as a task runner to generate the `.xcodeproj`.

1. `brew install mint`
2. `mint bootstrap -l`
3. `swish project`


- `FQAUTH_IOS_BUNDLE_ID` The bundle ID to use for the app.

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_BUNDLE_ID -w com.example.Haptics
  ```

- `FQAUTH_IOS_DEVELOPMENT_TEAM` The development team to use

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_DEVELOPMENT_TEAM -w ASDF1234
  ```

- `FQAUTH_IOS_API_KEY_ID` When deploying to the App Store, the API Key file to use

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_API_KEY_ID -w ARSTARST
  ```

- `FQAUTH_IOS_API_ISSUER_ID` When deploying to the App Store, the API Issuer to use.

  ```
  security add-generic-password -a $(whoami) -s FQAUTH_IOS_API_ISSUER_ID -w 10123456987
  ```
