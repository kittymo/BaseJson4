Pod::Spec.new do |s|
  s.name		= 'BaseJson4'
  s.version		= '1.0.1'
  s.summary		= 'Swift4 JSON to Object Model'
  s.homepage		= 'https://github.com/kittymo/BaseJson4'
  s.license		= { :type => "MIT" }
  s.author		= {'KittyMei' => 'kittymei1010@gmail.com'}
  s.ios.deployment_target = '11.0'
  s.osx.deployment_target = "10.13"
  s.source              = {:git => 'https://github.com/kittymo/BaseJson4.git', :tag => s.version}
  s.source_files 	= 'BaseJson4/BaseJson4.swift'
  s.requires_arc	= true
end
