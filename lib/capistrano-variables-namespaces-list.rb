# Copyright (c) 2009-2011 by Ewout Vonk. All rights reserved.

# prevent loading when called by Bundler, only load when called by capistrano
if caller.any? { |callstack_line| callstack_line =~ /^Capfile:/ }
  unless Capistrano::Configuration.respond_to?(:instance)
    abort "capistrano-variables-namespaces-list requires Capistrano 2"
  end

  module Capistrano
    module Configuration
      module VariablesWithNamespace
        def self.included(base) #:nodoc:
          %w(set).each do |m|
            base_name = m[/^\w+/]
            punct     = m[/\W+$/]
            base.send :alias_method, "#{base_name}_without_variable_namespace#{punct}", m
            base.send :alias_method, m, "#{base_name}_with_variable_namespace#{punct}"
          end
        end
      
        attr_reader :variables_namespaces
        
        def set_with_variable_namespace(variable, *args, &block)
          set_with_namespace({ :name => "top", :objekt => self }, variable, *args, &block)
        end

        def set_with_namespace(namespace, variable, *args, &block)
          @variables_namespaces ||= {}
          @variables_namespaces[variable.to_sym] ||= namespace
          set_without_variable_namespace(variable, *args, &block)
        end
      end
      
      module NamespaceExtensions
        def namespace_ancestors
          return [self] unless parent.is_a?(Capistrano::Configuration::Namespaces::Namespace)
          parent.namespace_ancestors + [self]
        end

        def set(variable, *args, &block)
          set_with_namespace({ :name => namespace_ancestors.map(&:name).join(':'), :objekt => self }, variable, *args, &block)
        end

        def set_with_namespace(namespace, variable, *args, &block)
          parent.set_with_namespace(namespace, variable, *args, &block)
        end
      end
    end
  end

  Capistrano::Configuration::Namespaces::Namespace.send(:include, Capistrano::Configuration::NamespaceExtensions)
  Capistrano::Configuration.send(:include, Capistrano::Configuration::VariablesWithNamespace)
end