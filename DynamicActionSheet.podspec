Pod::Spec.new do |spec|
  spec.name = "DynamicActionSheet"
  spec.version = "1.0.0"
  spec.summary = "DynamicActionSheet is a library to quickly create any custom action sheet controller."
  spec.homepage = "https://github.com/afr0man17/DynamicActionSheet"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Andres Rojas, Daniel Cardona" => 'd.cardona.rojas@gmail.com' }
  spec.swift_version = "5.0"
  spec.platform = :ios, "9.1"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/afr0man17/DynamicActionSheet.git", tag: "v#{spec.version}" }
  spec.source_files = "DynamicActionSheet/**/*.{h,swift}"
end
