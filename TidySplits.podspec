Pod::Spec.new do |s|
  s.name         = "TidySplits"
  s.version      = "0.9.0"
  s.summary      = "Another approach for SplitView layout written in Swift. Simple. Powerful."
  s.description  = <<-DESC
			TidySplits helps in sometimes complicated and messed up navigation. It simply manages two navigation stack and displays it in way as original Apple's UISplitViewController does.
                   DESC
  s.homepage     = "https://github.com/TomKaminski/TidySplits"
  s.license      = { :type => "MIT" }
  s.author             = { "Tomasz Kaminski" => "tkaminski93@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/TomKaminski/TidySplits.git", :tag => spec.version.to_s }
  s.source_files  = "Source/**/*.{h,m}"
  s.exclude_files = "Example/"
end
