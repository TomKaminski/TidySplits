Pod::Spec.new do |spec|
  spec.name = "TidySplits"
  spec.version = "2.0.6"
  spec.swift_version = "5.1"
  spec.summary = "Another approach for SplitView layout written in Swift. Simple. Powerful."
  spec.homepage = "https://github.com/TomKaminski/TidySplits"
  spec.license = "MIT"
  spec.author = { "Tomasz Kaminski" => "tkaminski93@gmail.com" }
  spec.source = { :git => "https://github.com/TomKaminski/TidySplits.git", :tag => spec.version }
  spec.source_files = "Source/**/*.swift"
  spec.requires_arc = true
  spec.ios.deployment_target = "9.0"
  spec.ios.frameworks = "UIKit", "Foundation"
end