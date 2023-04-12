# frozen_string_literal: true

require 'stringex'

module Sequel
  module Plugins
    # GenerateSlug plugin generates a unique slug based on the specified source
    # and additional columns. The plugin is designed to work with the Sequel
    # ORM.
    #
    # @example
    #   class Post < Sequel::Model
    #     plugin :generate_slug, column: 'slug', source: 'title', additional: 'identifier'
    #   end
    #
    #   post = Post.create(title: 'Hello World', identifier: 'abcdef')
    #   post.slug # => 'hello-world'
    #
    #   post = Post.create(title: 'Hello World', identifier: 'abcdef')
    #   post.slug # => 'hello-world-abcdef'
    #
    #   post = Post.create(title: 'Hello World', identifier: 'abcdef')
    #   post.slug # => 'hello-world-abcdef-1'
    module GenerateSlug
      # Configure the plugin with the given options.
      #
      # @param model [Sequel::Model] the model to configure the plugin for
      # @param opts [Hash] the options to configure the plugin with
      # @option opts [Symbol] :column (:slug) the column to store the generated slug
      # @option opts [Symbol] :source (:title) the source column to generate the slug from
      # @option opts [Symbol] :additional (:identifier) the additional column to use in slug generation if necessary
      def self.configure(model, opts = {})
        model.instance_exec do
          @slug_column = opts[:column] || :slug
          @source_column = opts[:source] || :title
          @additional_column = opts[:additional] || :identifier
        end
      end

      module ClassMethods
        # @!attribute [r] slug_column
        # @return [Symbol] the column to store the generated slug
        attr_reader :slug_column

        # @!attribute [r] source_column
        # @return [Symbol] the source column to generate the slug from
        attr_reader :source_column

        # @!attribute [r] additional_column
        # @return [Symbol] the additional column to use in slug generation if necessary
        attr_reader :additional_column

        Plugins.inherited_instance_variables(self, :@slug_column => nil, :@source_column => nil, :@additional_column => nil)
      end

      module InstanceMethods
        # Set the slug before validation if the record is new or the slug needs updating.
        def before_validation
          set_slug if new? || slug_needs_update?
          super
        end

        private

        # Generate a unique slug based on the source and additional columns.
        #
        # @return [String] the generated slug
        def generate_slug
          base_slug = get_column_value(model.source_column).to_url
          additional_column = get_column_value(model.additional_column)

          slug = find_unique_slug(base_slug, additional_column)
          slug ||= generate_slug_with_random_number(base_slug)

          slug
        end

        # Find a unique slug based on the given base_slug and additional_column.
        #
        # @param base_slug [String] the base slug to start with
        # @param additional_column [String, nil] the additional column value to use in slug generation if necessary
        # @return [String, nil] the unique slug or nil if not found
        def find_unique_slug(base_slug, additional_column)
          variations = [base_slug]
          variations << "#{base_slug}-#{additional_column}" unless additional_column.nil? || additional_column.empty?

          variations.each do |variation|
            return variation if self.class.where(model.slug_column.to_sym => variation).none?
          end

          nil
        end

        # Generate a unique slug with a random number appended to the base_slug.
        #
        # @param base_slug [String] the base slug to start with
        # @return [String] the generated slug with a random number appended
        def generate_slug_with_random_number(base_slug)
          loop do
            new_slug = "#{base_slug}-#{rand(1000)}"
            break new_slug if self.class.where(model.slug_column.to_sym => new_slug).none?
          end
        end

        # Check if the slug needs to be updated based on the modified columns.
        #
        # @return [Boolean] true if the slug needs to be updated, false otherwise
        def slug_needs_update?
          modified?(model.source_column.to_sym) || modified?(model.additional_column.to_sym)
        end

        # Set the slug for the model instance.
        #
        # @param slug [String] the slug to set
        # @return [void]
        def set_slug(slug = generate_slug)
          slug_column = model.slug_column
          method_name = :"#{slug_column}="

          set_column_value(method_name, slug) if respond_to?(slug_column) && respond_to?(method_name) && !modified?(slug_column)
        end
      end
    end
  end
end
