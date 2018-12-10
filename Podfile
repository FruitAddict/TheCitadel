source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '11.3'

def projectPods 
   pod 'Moya', :inhibit_warnings => true
end

def testingPods
   pod 'Quick', :inhibit_warnings => true
   pod 'Nimble', :inhibit_warnings => true
end

target 'TheCitadel' do
   use_frameworks!
   projectPods
end

target 'TheCitadelTests' do
   use_frameworks!
   projectPods
   testingPods
end

