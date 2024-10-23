# frozen_string_literal: true

module Mutations
  class UpdateCandidateProductCategoryIndicators < Mutations::BaseMutation
    argument :category_indicator_values, [GraphQL::Types::JSON], required: true
    argument :slug, String, required: true

    field :candidate_product, Types::CandidateProductType, null: true
    field :errors, [String], null: true

    def resolve(category_indicator_values:, slug:)
      candidate_product = CandidateProduct.find_by(slug:)
      candidate_product_policy = Pundit.policy(
        context[:current_user],
        candidate_product || CandidateProduct.new
      )
      unless candidate_product_policy.edit_allowed?
        return {
          candidate_product: nil,
          errors: ['Editing candidate product is not allowed.']
        }
      end

      updated_rubric_category_names = []
      category_indicator_values.each do |category_indicator_value|
        category_indicator = CategoryIndicator.find_by(slug: category_indicator_value['category_indicator_slug'])
        next if category_indicator.nil?

        current_category_indicators = CandidateProductCategoryIndicator.find_by(
          candidate_product_id: candidate_product.id,
          category_indicator_id: category_indicator.id
        )
        if current_category_indicators.nil?
          current_category_indicators = CandidateProductCategoryIndicator.new(
            candidate_product_id: candidate_product.id,
            category_indicator_id: category_indicator.id
          )
        end

        if category_indicator_value['value'].nil?
          updated_rubric_category_names << category_indicator.rubric_category.name
          current_category_indicators.destroy!
        else
          if current_category_indicators.indicator_value != category_indicator_value['value']
            updated_rubric_category_names << category_indicator.rubric_category.name
          end
          current_category_indicators.indicator_value = category_indicator_value['value']
          current_category_indicators.save!
        end
      end

      evaluation_update_text = <<-TRANSITION_TEXT
        <div class='flex flex-row gap-2 my-3'>
          <div class='font-semibold text-nowrap'>
            Evaluation updated
          </div>
          <div class='font-semibold'>
            →
          </div>
          <div class='font-semibold'>
            #{updated_rubric_category_names.uniq.join(', ')}.
          </div>
        </div>
      TRANSITION_TEXT

      successful_operation = false
      ActiveRecord::Base.transaction do
        candidate_product.save!
        calculate_maturity_scores(candidate_product.id)

        unless updated_rubric_category_names.empty?
          current_user = context[:current_user]
          comment = Comment.new(
            text: evaluation_update_text,
            comment_id: SecureRandom.uuid,
            comment_object_id: candidate_product.id,
            comment_object_type: 'CANDIDATE_PRODUCT',
            author: {
              id: current_user.id,
              username: current_user.username
            }
          )
          comment.save!
        end

        successful_operation = true
      end

      if successful_operation
        # Successful creation, return the created object with no errors
        {
          candidate_product: CandidateProduct.find_by(id: candidate_product.id),
          errors: []
        }
      else
        # Failed save, return the errors to the client
        {
          candidate_product: nil,
          errors: product.errors.full_messages
        }
      end
    end

    def calculate_maturity_scores(candidate_product_id)
      maturity_score = {}

      current_category_indicatorss =
        CandidateProductCategoryIndicator
        .where('candidate_product_id = ?', candidate_product_id)
        .map { |indicator| { indicator.category_indicator_id.to_s => indicator.indicator_value } }
        .reduce({}, :merge)

      rubric_categories = RubricCategory.includes(:rubric_category_descriptions)

      rubric_missing_score = 0
      rubric_overall_score = 0
      rubric_maximum_score = 0
      rubric_indicator_count = 0
      rubric_category_scores = []
      rubric_categories.each do |rubric_category|
        category_indicators = CategoryIndicator.where(rubric_category:)
                                               .includes(:category_indicator_descriptions)
        category_missing_score = 0
        category_overall_score = 0
        category_maximum_score = 0
        category_indicator_scores = []
        category_indicators.each do |category_indicator|
          indicator_value = current_category_indicatorss[category_indicator.id.to_s]
          indicator_type = category_indicator.indicator_type
          indicator_description = category_indicator.category_indicator_descriptions.first

          description = indicator_description&.description&.gsub(/<\/?[^>]*>/, '')
          score = convert_score_scale(indicator_value, indicator_type, category_indicator.weight)
          if score == 'N/A'
            category_missing_score += 1
          else
            category_overall_score += score
            category_maximum_score += category_indicator.weight * 10
          end

          category_indicator_scores << {
            'id' => category_indicator.id,
            'name' => category_indicator.name,
            'weight' => category_indicator.weight,
            'description' => description,
            'score' => score
          }
        end

        # Occasionally, rounding errors can lead to a score > 10
        category_overall_score = 10.0 if category_overall_score > 10

        # Update rubric level data
        rubric_overall_score += category_overall_score
        rubric_maximum_score += category_maximum_score

        # Update other metadata about the maturity
        rubric_missing_score += category_missing_score
        rubric_indicator_count += category_indicator_scores.count

        category_description = rubric_category.rubric_category_descriptions.first
        rubric_category_scores << {
          'id' => rubric_category.id,
          'name' => rubric_category.name,
          'weight' => rubric_category.weight,
          'description' => category_description&.description&.gsub(/<\/?[^>]*>/, ''),
          'overallScore' => category_overall_score,
          'maximumScore' => category_maximum_score,
          'missingScore' => category_missing_score,
          'categoryIndicators' => category_indicator_scores
        }

        maturity_score['rubricCategories'] = rubric_category_scores
      end

      # Now do final score calculation
      valid_category_count = 0
      overall_category_score = 0
      maturity_score['rubricCategories'].each do |category|
        if category['overallScore'].positive?
          valid_category_count += 1
          overall_category_score += category['overallScore'].to_f / category['maximumScore'].to_f
        end
      end

      if valid_category_count.positive?
        overall_maturity_score = overall_category_score.to_f / valid_category_count * 100
      end

      maturity_score['totalScore'] = rubric_overall_score&.round(2)
      maturity_score['maximumScore'] = rubric_maximum_score&.round(2)
      maturity_score['overallScore'] = overall_maturity_score&.round(2)

      # Other metadata for the rubric calculation.
      maturity_score['missingScore'] = rubric_missing_score
      maturity_score['indicatorCount'] = rubric_indicator_count

      candidate_product = CandidateProduct.find_by(id: candidate_product_id)
      candidate_product.maturity_score = JSON.parse(maturity_score.to_json)
      candidate_product.save!
    end

    def convert_score_scale(score, type, weight)
      return 'N/A' if score.nil? || score == 'N/A'

      numeric_value = 0

      case type
      when 'boolean'
        numeric_value = 10.0 * weight if %w[true t].include?(score)
      when 'scale'
        case score
        when 'medium'
          numeric_value = 5.0 * weight
        when 'high'
          numeric_value = 10.0 * weight
        end
      when 'numeric'
        numeric_value = score.to_f * weight
      end
      numeric_value
    end
  end
end
