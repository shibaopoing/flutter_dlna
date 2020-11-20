#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_dlna.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_dlna'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.libraries = 'icucore', 'c++', 'z', 'xml2'
  s.source_files = 'Classes/**/*','MRDLNA/Classes/ARC/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'CocoaAsyncSocket'
  s.platform = :ios, '8.0'
  s.xcconfig = {
      'HEADER_SEARCH_PATHS' => '${SDKROOT}/usr/include/libxml2',
      'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES'
  }

  s.subspec 'MRC' do |sp|
      sp.source_files = 'MRDLNA/Classes/MRC/**/*'
      sp.requires_arc = false
  end
  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
