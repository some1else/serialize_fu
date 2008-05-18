module SerializeFu
    def self.included(base)
        base.send(:extend, ClassMethods)
        base.send(:include, InstanceMethods)
        base.send(:alias_method_chain, :to_xml, :hidden_attributes_and_exposed_methods)
        base.send(:alias_method_chain, :to_json, :hidden_attributes_and_exposed_methods)
    end
    
    module ClassMethods
        def attr_hidden(*attributes)
            write_inheritable_array("attr_hidden", attributes - (hidden_attributes || []))
        end
        def method_exposed(*attributes)
            write_inheritable_array("method_exposed", attributes - (exposed_methods || []))
        end
        def hidden_attributes
            read_inheritable_attribute("attr_hidden")
        end
        def exposed_methods
            read_inheritable_attribute("method_exposed")
        end
    end
    module InstanceMethods
        def to_json_with_hidden_attributes_and_exposed_methods(options = {})
            options[:except] ||= []
            options[:except] += self.class.hidden_attributes unless self.class.hidden_attributes.nil?
            options[:methods] ||= []
            options[:methods] += self.class.exposed_methods unless self.class.exposed_methods.nil?
            to_json_without_hidden_attributes_and_exposed_methods(options)
        end
        def to_xml_with_hidden_attributes_and_exposed_methods(options = {})
            options[:except] ||= []
            options[:except] += self.class.hidden_attributes unless self.class.hidden_attributes.nil?
            to_xml_without_hidden_attributes_and_exposed_methods(options)
        end
    end
end