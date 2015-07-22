Pod::Spec.new do |s|
  s.name = 'BigBangClient'
  s.version = '0.0.1'
  s.license = 'MIT'
  s.authors      = { 'Jonathan Wagner' => 'tigeba@altereality.com' }
  s.source       = { :git => "https://github.com/bigbang/bigbang-client-swift.git", :tag => s.version }

  s.summary = 'Create realtime applications in seconds with Big Bang.'
  s.description = 'Big Bang lets you create realtime applications in seconds. It makes event streaming and data synchronization a snap!'
  s.social_media_url = 'http://twitter.com/getbigbang'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'

  s.prefix_header_file = 'BigBangClient/BigBangClient.h'
  s.source_files = 'BigBangClient/*.swift'
  s.requires_arc = true

  s.dependency 'Alamofire',  '~> 1.2'
  s.dependency 'SwiftyJSON', '~> 2.2.0'
  s.dependency 'Starscream', '~> 0.9.3'
end
