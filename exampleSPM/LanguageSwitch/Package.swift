import PackageDescription

let package = Package(
    name: "Sample",
    dependencies: [
        .Package(url: "https://github.com/marmelroy/Localize-Swift", versions: "0.6" ..< Version.max),
    ]
)
