Pod::Spec.new do |s|
s.name         = "ZJPickerView"
s.version      = "2.0.1"
s.summary      = "A fast, convenient view to show pickerView."
s.description  = <<-DESC
A fast, convenient view to show pickerView, it support full Customization.
DESC
s.homepage     = "https://github.com/Abnerzj/ZJPickerView"
# s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
s.license      = { :type => "MIT", :file => "LICENSE" }
s.author             = { "Abnerzj" => "Abnerzj@163.com" }
s.social_media_url   = "http://weibo.com/ioszj"
s.platform     = :ios, "7.0"
s.source       = { :git => "https://github.com/Abnerzj/ZJPickerView.git", :tag => "#{s.version}" }
s.source_files  = "ZJPickerView/*.{h,m}"
s.requires_arc = true
end
