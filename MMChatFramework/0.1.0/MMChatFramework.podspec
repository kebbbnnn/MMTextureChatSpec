#
#  Be sure to run `pod spec lint MMChatFramework.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

 # 1
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.name = "MMChatFramework"
  s.summary = "AsyncDisplayKit(Texture) smooth scroll Chat Simulation"
  s.requires_arc = true

  # 2
  s.version = "0.1.1"

  # 3
  s.license = { :type => "MIT", :file => "LICENSE" }

  # 4 - Replace with your name and e-mail address
  s.author = { "Kevin Ladan" => "kevinladan@outlook.com" }

  # 5 - Replace this URL with your own Github page's URL (from the address bar)
  s.homepage = "https://github.com/kebbbnnn/MMTextureChatSpec"


  # 6 - Replace this URL with your own Git URL from "Quick Setup"
  s.source = { :git => "https://github.com/kebbbnnn/MMTextureChatSpec.git", :tag => "#{s.version}"}


  # 7
  s.framework = "UIKit"
  s.dependency 'MBPhotoPicker'
  s.dependency 'Texture'
  s.dependency 'DropDown'
  s.dependency 'Toolbar'
  s.dependency 'ionicons'

  # 8
  s.source_files = "MMChatFramework/**/*.{swift}"

  # 9
  s.resources = "MMChatFramework/**/*.{png,jpeg,jpg,storyboard,xib}"
end

