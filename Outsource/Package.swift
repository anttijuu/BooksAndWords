// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
   name: "Outsource",
   platforms: [
      .macOS(.v10_15)
   ],
   products: [
      .executable(name: "outsource", targets: ["Outsource"])
   ],
   dependencies: [
      .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0")
   ],
   targets: [
      .executableTarget(
         name: "Outsource",
         dependencies: [.product(name: "ArgumentParser", package: "swift-argument-parser")]),
   ]
)
