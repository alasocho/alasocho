module ActionView
  module Helpers
    module FormTagHelper
      def submit_tag(text="Save changes", options={})
        options.stringify_keys!

        if disable_with = options.delete("disable_with")
          options["data-disable-with"] = disable_with
        end

        if confirm = options.delete("confirm")
          add_confirm_to_attributes!(options, confirm)
        end

        options = { type: "submit", name: "commit" }.update(options)
        content_tag :button, text, options
      end
    end
  end
end
