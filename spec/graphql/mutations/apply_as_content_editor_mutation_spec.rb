# frozen_string_literal: true

require 'graph_helpers'
require 'rails_helper'

RSpec.describe(Mutations::ApplyAsContentEditor, type: :graphql) do
  let(:mutation) do
    <<~GQL
      mutation ApplyAsContentEditor {
        applyAsContentEditor {
          candidateRole {
            email
            roles
            description
          }
          errors
        }
      }
    GQL
  end

  it 'creates content editor role - user is logged in' do
    create(:user, email: 'admin-user@gmail.com', roles: ['admin'], receive_admin_emails: true)
    user = create(:user, email: 'user@gmail.com')

    result = execute_graphql_as_user(
      user,
      mutation
    )

    aggregate_failures do
      expect(result['data']['applyAsContentEditor']['candidateRole'])
        .to(eq({
          "description" => "Content editor role requested from the new UX.",
          "email" => "user@gmail.com",
          "roles" => ["content_editor"]
        }))
      expect(result['data']['applyAsContentEditor']['errors'])
        .to(eq([]))
    end

    result = execute_graphql_as_user(
      user,
      mutation
    )

    aggregate_failures do
      expect(result['data']['applyAsContentEditor']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsContentEditor']['errors'])
        .to(eq(['Pending content editor request already exists.']))
    end
  end

  it 'fails - user is not logged in' do
    result = execute_graphql(
      mutation
    )

    aggregate_failures do
      expect(result['data']['applyAsContentEditor']['candidateRole'])
        .to(be(nil))
      expect(result['data']['applyAsContentEditor']['errors'])
        .to(eq(['Must be logged in to apply as content editor.']))
    end
  end
end
