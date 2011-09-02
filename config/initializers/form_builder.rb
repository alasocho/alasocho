require "nokogiri"

module ALasOcho
  class FormBuilder < ActionView::Helpers::FormBuilder
    def form_field(method, options={}, &block)
      options[:class] = Array(options[:class])
      options[:class] << "form_field" << "clearfix"
      options[:class] << "error" if @object.errors[method].any?
      options[:class].uniq!

      @template.content_tag(:div, @template.content_tag(:div, @template.capture(&block), class: "input"), options)
    end

    def form_stack(options={}, &block)
      options[:class] = Array(options[:class])
      options[:class] << "form_field" << "clearfix"
      options[:class].uniq!

      if text = options.delete(:label)
        prefix = @template.content_tag(:label, text)
      else
        prefix = ""
      end

      @template.content_tag(:div, prefix.html_safe + @template.content_tag(:ul, @template.capture(&block), class: "inputs-list"), options)
    end

    def stack_field(method, options={}, &block)
      options[:for] ||= "#{@object_name}_#{method}"

      @template.content_tag(:li, @template.content_tag(:label, @template.capture(&block), options))
    end

    def errors(method, options={})
      options.reverse_merge!(block: false)
      klass = options[:block] ? "help-block" : "help-inline"

      messages = @object.errors[method]
      @template.content_tag(:span, messages.to_sentence, class: "#{klass} error") if messages.any?
    end

    def submit(value=nil, options={})
      super(value, { :class => ["btn", "primary"] }.merge(options))
    end
  end
end

ActiveSupport.on_load(:action_view) do
  ActionView::Base.default_form_builder = ALasOcho::FormBuilder

  ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
    extend ActionView::Helpers::OutputSafetyHelper

    node = Nokogiri(html_tag).first_element_child
    node["class"] = (Array(node["class"]) << "error").join(" ")
    raw node.to_html
  end
end
