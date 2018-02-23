// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "todoco",
    products: [
        .executable(name: "todoco", targets: ["ToDoCo"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "3.0.0"),
        .package(url: "https://github.com/kylef/Commander", from: "0.8.0"),
        .package(url: "https://github.com/behrang/YamlSwift.git", from: "3.4.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "0.5.0"),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", from: "4.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. 
        // A target can define a module or a test suite.
        // Targets can depend on other targets in this package, 
        // and on products in packages which this package depends on.
        .target(
            name: "ToDoCo",
            dependencies: [
                "ToDoCoConfig",
                "Commander",
                "CLQuestions",
                "Ignore",
                "ToDoCoReader"
            ]),
        .target(
            name: "ToDoCoConfig",
            dependencies: ["Yaml", "Rainbow", "Yams", "Ignore"]),
        .testTarget(
            name: "ToDoCoConfigTests",
            dependencies: ["Quick", "Nimble", "ToDoCoConfig", "Yaml"]),
        .target(
            name: "CLQuestions",
            dependencies: ["Rainbow"]),
        .testTarget(
            name: "CLQuestionsTests",
            dependencies: ["Quick", "Nimble", "CLQuestions"]),
        .target(
            name: "Ignore",
            dependencies: []),
        .testTarget(
            name: "IgnoreTests",
            dependencies: ["Quick", "Nimble", "Ignore"]),
        .target(
            name: "ToDo",
            dependencies: []),
        .testTarget(
            name: "ToDoTests",
            dependencies: ["Quick", "Nimble", "ToDo"]),
        .target(
            name: "ToDoCoReader",
            dependencies: ["ToDo", "ToDoCoConfig", "Ignore"]),
        .testTarget(
            name: "ToDoCoReaderTests",
            dependencies: ["Quick", "Nimble", "ToDoCoReader"])
    ]
)
