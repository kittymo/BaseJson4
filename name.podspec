Pod::Spec.new do |s|
  s.name		= 'BaseJson4'
  s.version		= '1.0'
  s.summary		= 'Swift4 JSON to Object Model'
  s.homepage		= 'https://github.com/kittymo/BaseJson4'
  s.license		= 'MIT'
  s.platform		= :ios
  s.author		= {'KittyMei' => 'kittymei1010@gmail.com'}
  s.ios.deployment_target = '9.0'
  s.source              = {:git => 'https://github.com/kittymo/BaseJson4.git', :tag => s.version}
  s.source_files 	= 'BaseJson4/*.{swift}'
  s.resources  		= 'BaseJson4/resource/*.{png,xib,nib,storyboard,bundle}'
  s.requires_arc	= true
  s.frameworks		= 'UIKit'
end
