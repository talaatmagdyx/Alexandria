class FieldPicker

  def initialize(presenter)
    @presenter = presenter
    @fields = @presenter.params[:fields]
  end

  # the pick method will either get the list of fields from validate_fields
  # if it didn’t get nil back, or from pickable which is basically the entire list of attributes.
  # After this, it will loop through each field,
  # check if it’s defined on the presenter and either call it on the presenter or on the model.
  # It will then add the key/value inside the presenter data attribute.
  def pick
    (validate_fields || pickable).each do |field|
      value = (@presenter.respond_to?(field) ? @presenter :
                   @presenter.object).send(field)
      @presenter.data[field] = value
    end

    @presenter
  end

  private
  # The function of validate_fields is to ensure that only allowed fields
  # go through the filtering process. It uses pickable and the reject method 
  # to ensure that. If no specific fields were requested by the client, 
  # it will just return nil.
  
  def validate_fields
    return nil if @fields.blank?
    # can use
    # validated = @fields.split(',').reject { |f| !pickable.include?(f) }
    validated = @fields.split(',').select { |f| pickable.include?(f) }
    validated.any? ? validated : nil
  end
  # pickable method which is going to extract the build_attributes from the presenter 
  # and store them in the @pickable instance variable.
  def pickable
    @pickable ||= @presenter.class.build_attributes
  end

end