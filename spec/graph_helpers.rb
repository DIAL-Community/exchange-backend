# frozen_string_literal: true

require 'factory_bot'

module GraphHelpers
  def controller
    @controller ||= GraphqlController.new.tap do |obj|
      obj.set_request!(ActionDispatch::Request.new({}))
    end
  end

  def execute_graphql(query, **kwargs)
    RegistrySchema.execute(
      query,
      context: {
        operation_context: kwargs[:operation_context] || VIEWING_CONTEXT
      },
      variables: kwargs[:variables]
    )
  end

  def execute_graphql_as_user(user, query, **kwargs)
    RegistrySchema.execute(
      query,
      context: {
        current_user: user,
        operation_name: kwargs[:operation_name],
        operation_context: kwargs[:operation_context] || VIEWING_CONTEXT
      },
      variables: kwargs[:variables]
    )
  end
end

RSpec.configure do |config|
  config.include(GraphHelpers, type: :graphql)
  config.include(FactoryBot::Syntax::Methods)
end
