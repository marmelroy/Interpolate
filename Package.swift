// swift-tools-version:4.2
import PackageDescription

let package = Package(
  name: "Interpolate",
  products: [
      // Products define the executables and libraries produced by a package, and make them visible to other packages.
      .library(
          name: "Interpolate",
          targets: ["Interpolate"]),
  ],
  dependencies: [
      // Dependencies declare other packages that this package depends on.
      // .package(url: /* package url */, from: "1.0.0"),
  ],
  targets: [
      .target(
          name: "Interpolate",
          path: "Interpolate"
    ),
      .testTarget(
          name: "InterpolateTests",
          dependencies: ["Interpolate"],
          path: "InterpolateTests"
    ),
  ]
)
