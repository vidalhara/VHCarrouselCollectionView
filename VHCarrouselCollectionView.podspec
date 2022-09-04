Pod::Spec.new do |spec|

  spec.name         = "VHCarrouselCollectionView"
  spec.version      = "1.0.1"
  spec.summary      = "VHCarrouselCollectionView is an horizontal UICollectionView written in Swift which loops infinitely."

  spec.homepage     = "https://github.com/vidalhara/VHCarrouselCollectionView"

  spec.license      = "MIT"

  spec.author       = "Vidal HARA"
  spec.documentation_url = 'https://vidalhara.github.io/VHCarrouselCollectionView/'
  
  spec.ios.deployment_target = '10.0'
  spec.swift_versions = ['4.0', '5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']

  spec.source       = { :git => "https://github.com/vidalhara/VHCarrouselCollectionView.git", :tag => spec.version.to_s }
  
  spec.source_files = "Sources/**/*.swift"
  spec.frameworks = "UIKit"
end
