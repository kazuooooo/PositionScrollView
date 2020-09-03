Pod::Spec.new do |spec|
  spec.name         = "PositionScrollView"
  spec.version      = "1.0.2"
  spec.summary      = "ScrollView to get, set scroll position"
  spec.description  = <<-DESC
  Position Scroll View is pure Swift UI Scroll View which can get or move scroll position.
  DESC
  spec.homepage     = "https://github.com/kazuooooo/PositionScrollView"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "author" => "matsumotokazuya7@gmail.com" }
  spec.documentation_url = "https://github.com/kazuooooo/PositionScrollView"
  spec.platforms = { :ios => "13.0" }
  spec.swift_version = "5.2"
  spec.source       = { :git => "https://github.com/kazuooooo/PositionScrollView.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/PositionScrollView/**/*.swift"
  spec.xcconfig = { "SWIFT_VERSION" => "5.2" }
end