# frozen_string_literal: true
available_locales = ["en", "es", "pt", "sw", "de", "cs", "fr"]

Product.all.each do |product|
  available_locales.each do |locale|
    _latest_description, *other_descriptions = ProductDescription.where(product_id: product.id, locale: locale)
                                                                 .order(created_at: :desc)
    next if other_descriptions.nil? || other_descriptions.empty?
    # Delete other description and use the latest description as the correct value.
    other_descriptions.each(&:destroy)
  end
end

Dataset.all.each do |dataset|
  available_locales.each do |locale|
    _latest_description, *other_descriptions = DatasetDescription.where(dataset_id: dataset.id, locale: locale)
                                                                 .order(created_at: :desc)
    next if other_descriptions.nil? || other_descriptions.empty?
    # Delete other description and use the latest description as the correct value.
    other_descriptions.each(&:destroy)
  end
end
