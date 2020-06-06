class BasePresenter
  # use Meta Programming
  # if not love meta programming please look below
  #
  include Rails.application.routes.url_helpers

  CLASS_ATTRIBUTES = {
      build_with: :build_attributes,
      related_to: :relations,
      sort_by: :sort_attributes,
      filter_by: :filter_attributes
  }.freeze

  CLASS_ATTRIBUTES.each { |_k, v| instance_variable_set("@#{v}", []) }

  class << self
    attr_accessor *CLASS_ATTRIBUTES.values

    CLASS_ATTRIBUTES.each do |k, v|
      define_method k do |*args|
        instance_variable_set("@#{v}", args.map(&:to_s))
      end
    end
    def cached
      @cached = true
    end

    def cached?
      @cached
    end
  end


  attr_accessor :object, :params, :data

  def initialize(object, params, options = {})
    @object = object
    @params = params
    @options = options
    @data = HashWithIndifferentAccess.new
  end

  def as_json(*)
    @data
  end


  def build(actions)
    actions.each { |action| send(action) }
    self
  end

  # To build the cache key, we need the list of requested fields
  # sorted to make it reusable
  def validated_fields
    @fields_params ||= field_picker.fields.sort.join(',')
  end

  # Same for embeds
  def validated_embeds
    @embed_params ||= embed_picker.embeds.sort.join(',')
  end

  def fields
    FieldPicker.new(self).pick
  end

  def embeds
    EmbedPicker.new(self).embed
  end

  private

  def field_picker
    @field_picker ||= FieldPicker.new(self)
  end

  def embed_picker
    @embed_picker ||= EmbedPicker.new(self)
  end

end

# replace meta programming code
=begin
# Define a class level instance variable
  @build_attributes = []
  @relations = []
  @sort_attributes = []
  @filter_attributes = []

  class << self
    # Define the accessors for the attributes created
    # above
    attr_accessor :relations, :sort_attributes,
                  :filter_attributes, :build_attributes
    # Create the actual class method that will
    # be used in the subclasses
    # We use the splash operation '*' to get all
    # the arguments passed in an array
    def build_with(*args)
      @build_attributes = args.map(&:to_s)
    end

    # Add a bunch of methods that will be used in the
    # model presenters
    def related_to(*args)
      @relations = args.map(&:to_s)
    end

    def sort_by(*args)
      @sort_attributes = args.map(&:to_s)
    end

    def filter_by(*args)
      @filter_attributes = args.map(&:to_s)
    end
  end
=end