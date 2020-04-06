$release_xconfig = <<-STR
DEVELOPMENT_TEAM = #{ENV["DEVELOPMENT_TEAM"]}
BUNDLE_PREFIX = #{ENV["BUNDLE_PREFIX"]}
PRODUCT_BUNDLE_IDENTIFIER = #{ENV["PRODUCT_BUNDLE_IDENTIFIER"]}
PRODUCT_NAME = #{ENV["PRODUCT_NAME"]}
KEYCHAIN_GROUP = #{ENV["KEYCHAIN_GROUP"]}
APP_BUILD_VERSION = #{ENV["APP_BUILD_VERSION"]}
APP_BUILD_NUMBER = #{ENV["APP_BUILD_NUMBER"]}
STR

module Fastlane
    module Actions
      class CreateXconfigAction < Action
        def self.run(params)
          Dir.mkdir('temp') unless Dir.exist?('temp')
          File.open('temp/Config.xconfig', 'w') { |file| file.write($release_xconfig) }
        end
  
        def self.description
          "Add tag"
        end
  
        def self.details
          "Add tag to project"
        end
  
        def self.available_options
        end
  
        def self.output
        end
  
        def self.return_value
          nil
        end
  
        def self.authors
          ["muiz.idn"]
        end
  
        def self.is_supported?(platform)
          true
        end
      end
    end
  end