class BaseService
  def method_missing(name, *args, &block)
    if self.class.transactions.keys.include?(name)
      input, step_args, trns_args = args

      input ||= {}
      step_args ||= {}
      trns_args ||= {}
      transactions[name] ||= self.class.transactions[name].new(trns_args)

      steps = transactions[name].steps.map(&:step_name)

      if transactions[name].steps.detect { |s| s.step_name === :validate }
        step_args = step_args.merge validate_step_args(name)
      end

      step_args = step_args.merge with_step_args(name)
      step_args = step_args.slice(*steps)

      transactions[name]
        .with_step_args(step_args)
        .call(input)
    else
      super
    end
  end

  def respond_to_missing?(name, include_private = false)
    self.class.transactions.keys.include?(name) || super
  end

  def transactions
    @transactions ||= {}
  end

  def with_step_args(name)
    {}
  end

  private

  def validate_step_args(name)
    Hash(validate: [schema_for(name)])
  end

  def schema_for(name)
    klass = [
      self.class.name.split('::').slice(0),
      'Schemas',
      "#{name.to_s.camelize}Schema"
    ].join('::')

    Object.const_get(klass)
  end
end
