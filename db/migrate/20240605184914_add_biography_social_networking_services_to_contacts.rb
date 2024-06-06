# frozen_string_literal: true

class AddBiographySocialNetworkingServicesToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column(:contacts, :biography, :text)
    add_column(:contacts, :social_networking_services, :jsonb, default: [])
    add_column(:contacts, :source, :string, default: 'exchange')
  end
end
