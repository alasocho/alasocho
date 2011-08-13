module ALasOcho
  class FormBuilder < ActionView::Helpers::FormBuilder
    def errors(method)
      messages = @object.errors[method]
      @template.content_tag(:span, messages.to_sentence, class: "errors", id: "error_for_#{@object_name}_#{method}") if messages.any?
    end
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Base.default_form_builder = ALasOcho::FormBuilder
end
