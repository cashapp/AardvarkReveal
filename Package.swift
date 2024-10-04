// swift-tools-version:5.10

import PackageDescription

let package = Package(
	name: "AardvarkReveal",
	platforms: [
		.iOS(.v14),
	],
	products: [
		.library(
			name: "AardvarkReveal",
			targets: ["AardvarkReveal"]
		),
        .library(
            name: "AardvarkRevealCompression",
            targets: ["AardvarkRevealCompression"]
        )
	],
	dependencies: [
		.package(
            url: "https://github.com/square/Aardvark",
            .upToNextMajor(from: "5.2.0")
        ),
	],
	targets: [
		.target(
			name: "AardvarkReveal",
			dependencies: [
                .product(name: "Aardvark", package: "Aardvark"),
                .target(name: "AardvarkRevealCompression"),
            ],
            cSettings: [
                .define("SWIFT_PACKAGE"),
            ]
		),
        .target(
            name: "AardvarkRevealCompression",
            cSettings: [
                .define("SWIFT_PACKAGE"),
            ]
        ),
	]
)
