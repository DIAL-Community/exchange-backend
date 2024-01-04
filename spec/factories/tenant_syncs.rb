FactoryBot.define do
  factory :tenant_sync do
    tenant_source { 'public' }
    tenant_destination { 'fao' }
    sync_configuration { "" }
  end
end
