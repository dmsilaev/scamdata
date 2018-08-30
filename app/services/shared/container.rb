module Shared
  Container = Dry::Container::Namespace.new('shared') do
    register('validate') { Operations::Validate.new }
    register('authorize') { Operations::Authorize.new }
    register('present') { Operations::Present.new }
    register('dummy') { Operations::Dummy.new }
  end
end
