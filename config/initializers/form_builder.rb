module ALasOcho
  class FormBuilder < ActionView::Helpers::FormBuilder
    def label(method, text=nil, options={}, &block)
      if block.nil?
        options.stringify_keys!

        text ||= I18n.t("helpers.label.#{@object_name}.#{method}", :default => "").presence
        text ||= @object && @object.class.respond_to?(:human_attribute_name) &&
          @object.class.human_attribute_name(method)

        unless options.fetch("errors", false)
          text = [text, errors(method)].compact.join(" ").html_safe
        end

        options.delete("errors")
      end

      super(method, text, options, &block)
    end

    def errors(method)
      messages = @object.errors[method]
      @template.content_tag(:span, messages.to_sentence, class: "errors") if messages.any?
    end
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Base.default_form_builder = ALasOcho::FormBuilder
end
