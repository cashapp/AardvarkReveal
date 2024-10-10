Pod::Spec.new do |s|
  s.name     = 'AardvarkReveal'
  s.version  = '2.0.0'
  s.license  = 'Apache License, Version 2.0'
  s.summary  = 'Aardvark components for generating a bug report attachment containing a Reveal file.'
  s.homepage = 'https://github.com/cashapp/AardvarkReveal'
  s.authors  = 'Square'
  s.source   = { :git => 'https://github.com/cashapp/AardvarkReveal.git', :tag => "AardvarkReveal/#{ s.version.to_s }" }

  s.swift_version = '5.0'
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/AardvarkReveal/**/*.swift', 'Sources/AardvarkRevealCompression/**/*.{h,m}'

  s.dependency 'Aardvark', '~> 5.0'

  s.test_spec 'UnitTests' do |ts|
    ts.source_files = 'Tests/AardvarkRevealTests/**/*.{h,m,swift}'
  end
end
