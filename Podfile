platform :ios, '12.0'

target 'MeteoLV' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod 'MeteoLVProvider'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    next unless target.name.start_with?('SwiftSoup')
    target.build_configurations.each do |config|
      next unless config.name.start_with?('Release')
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end
  end
end
