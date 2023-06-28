# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'OwnerApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EmployeeApp
  pod 'IQKeyboardManagerSwift'
#  pod "RappleProgressHUD"
  pod 'Alamofire', '~> 4.7'
  pod 'SDWebImage', '~> 5.0'
  pod 'SCLAlertView'
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'ProgressHUD', '~> 13.6'
end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
             end
        end
   end
end
