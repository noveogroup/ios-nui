Pod::Spec.new do |s|
  s.name             = "NUIKit"
  s.version          = "1.0"
  s.summary          = "Libraries for simplifying work with UI on iOS."
  s.homepage         = "https://github.com/noveogroup/ios-nui"
  s.license          = 'MIT'
  s.author           = { "Ivan Masalov" => "ivan.masalov@noveogroup.com" }
  s.source           = { :git => "https://github.com/noveogroup/ios-nui.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'NUIKit/NUIKit/**/*.{h,m}'

  s.public_header_files = 'NUIKit/NUIKit/**/*.h'
  s.frameworks = 'Foundation', 'UIKit'
end
