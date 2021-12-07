Pod::Spec.new do |s|
  s.name             = 'map4d_map_utils'
  s.version          = '0.0.1'
  s.summary          = 'Map4dMapUtils SDK for Flutter'
  s.description      = <<-DESC
  A Flutter plugin that provides utility library for map4d_map.
                       DESC
  s.homepage         = 'https://map4d.vn'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'IOTLink' => 'admin@iotlink.com.vn' }
  s.source           = { :path => '.' }
  s.platform         = :ios, '9.3'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.source_files        = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'

  s.dependency 'Flutter'
  s.dependency 'Map4dMapUtils'
end
