Pod::Spec.new do |spec|
  spec.name         = "BitizenConnectSwift"
  spec.version      = "1.7.0"
  spec.summary      = "A delightful way to integrate BitizenConnect into your app."
  spec.description  = <<-DESC
  BitizenConnect protocol implementation for enabling communication between dapps and
  wallets. This library provides both client and server parts so that you can integrate
  it in your wallet, or in your dapp - whatever you are working on.
                   DESC
  spec.homepage     = "https://github.com/BitizenWallet/BitizenConnectSwift"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author             = { "Bitizen" => "dev@bitizen.org" }
  spec.cocoapods_version = '>= 1.4.0'
  spec.platform     = :ios, "13.0"
  spec.swift_version = "5.0"
  spec.source       = { :git => "https://github.com/BitizenWallet/BitizenConnectSwift.git", :tag => "#{spec.version}" }
  spec.source_files  = "Sources/**/*.swift"
  spec.requires_arc = true
  spec.dependency "CryptoSwift", "~> 1.5"
end
