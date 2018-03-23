#
# Be sure to run `pod lib lint FATextField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FATextField'
  s.version          = '0.1.5'
  s.summary          = 'add Start and Top padding'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

#s.description      = <<-DESC TODO: Add long description of the pod here. DESC

  s.homepage         = 'https://github.com/fadizant/FATextField'
  s.screenshots      = 'http://www.m5zn.com/newuploads/2017/09/21/gif//10eefedfc32ba63.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fadizant' => 'fadizant@hotmail.com' }
  s.source           = { :git => 'https://github.com/fadizant/FATextField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FATextField/Classes/**/*'
  
   s.resource_bundles = {
     'FATextField' => ['FATextField/Assets/*.xcassets']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
