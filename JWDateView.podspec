Pod::Spec.new do |s|

  s.name         = "JWDateView"
  s.version      = "0.0.1"
  s.summary      = "自定义事件选择控件，支持公历与农历"
  s.homepage     = "https://github.com/Javen-fly/JWDateView"
  s.license      = "MIT"
  s.author       = { "Javenfly" => "960838547@qq.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/Javen-fly/JWDateView.git", :tag => "0.0.1" }

  s.source_files  = "JWDateView", "JWDateView/**/*.{h,m}"

  s.framework  	= "UIKit"
  s.dependency 'JWPickerView'
  s.dependency 'JWLunarCalendarDB'

end
