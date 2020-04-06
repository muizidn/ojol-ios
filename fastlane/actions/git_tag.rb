module Fastlane
  module Actions
    class GitTagAction < Action
      def self.run(params)
        branch_name = `git symbolic-ref --short HEAD`
        branch_name.delete!("\n")
        build_version = ENV["APP_BUILD_VERSION"].to_s
        build_number = ENV["APP_BUILD_NUMBER"].to_i

        tag_name = "#{branch_name}/#{build_version}\(#{build_number}\)"
        `git tag #{branch_name}/#{build_version}\\(#{build_number}\\)`
        UI.message "Tag : #{tag_name}"
      end

      def self.description
        "Add tag"
      end

      def self.details
        "Add tag to project"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :path,
                                       description: "Path to .plist file",
                                       is_string: true,
                                       verify_block: proc do |value|
                                       end),
        ]
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