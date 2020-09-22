Pod::Spec.new do |s|

# 1
s.platform = :ios
s.ios.deployment_target = '8.0'
s.name = "SmartConnect"
s.summary = "SmartConnect library is used to connect to SmartPay devices."
s.requires_arc = true

# 2
s.version = "0.1.0"

# 3
s.license = { :type => "MIT", :file => "LICENSE" }

# 4 - Replace with your name and e-mail address
s.author = { "Hanuman Kachwa" => "hanuman@abacus.co" }

# 5 - Replace this URL with your own GitHub page's URL (from the address bar)
s.homepage = "https://github.com/hanumanAbacus/SmartConnect"

# 6 - Replace this URL with your own Git URL from "Quick Setup"
s.source = { :git => "https://github.com/hanumanAbacus/SmartConnect.git",
:tag => "#{s.version}" }

# 7
s.framework = "UIKit"
s.dependency 'Alamofire', '~> 4.8.2'
s.dependency 'Gloss', '~> 3.0.0'
s.dependency 'Moya', '~> 13.0.1'
s.dependency 'ReachabilitySwift', '~> 4.3.0'

# 8
s.source_files = "SmartConnect/**/*.{h}"

# 9
s.resources = "SmartConnect/**/*.{png,jpeg,jpg,storyboard,xib,xcassets}"

# 10
s.swift_version = "4.2"

end
