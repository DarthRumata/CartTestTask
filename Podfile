platform :ios, '11.4'

def common_pods
  pod 'Kingfisher', '~> 4.6'
  pod 'Swinject', '~> 2.5'
  pod 'SwinjectAutoregistration', '~> 2.5'
  pod 'RxSwift', '~> 4.1'
  pod 'EventsTree', '~> 1.0'
  pod 'RxOptional', '~> 3.5'
  
end

target 'OwoxCart' do
  use_frameworks!
  
  common_pods
  pod 'Reusable', '~> 4.0'
  pod 'RxDataSources', '~> 3.0'
  pod 'RxViewController', '~> 0.3'
  pod 'SwiftLint', '~> 0.25'
  pod 'ValueStepper', '~> 1.5'
  
end

target 'Core' do
  use_frameworks!
  
  common_pods
  pod 'Unbox', '~> 3.0'

end

target 'SwiftGen' do
  use_frameworks!
  
  pod 'SwiftGen', '~> 6.0.2'
  
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'ValueStepper'
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '4'
      end
    end
    target.build_configurations.each do |config|
      config.build_settings.delete('CODE_SIGNING_ALLOWED')
      config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
  end
end
