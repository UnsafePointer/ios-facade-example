platform :ios, '7.0'
pod 'AFNetworking', '~> 2.0.3'
pod 'TMCache', '~> 1.2.0'
pod 'MagicalRecord', '~> 2.2'
pod 'Mantle', '~> 1.3.1'
pod 'CocoaLumberjack', '~> 1.7.0'
post_install do |installer|
  target = installer.project.targets.find{|t| t.to_s == "Pods-MagicalRecord"}
    target.build_configurations.each do |config|
        s = config.build_settings['GCC_PREPROCESSOR_DEFINITIONS']
        s = [ '$(inherited)' ] if s == nil;
        s.push('MR_ENABLE_ACTIVE_RECORD_LOGGING=0') if config.to_s == "Debug";
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = s
    end
end