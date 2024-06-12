# frozen_string_literal: true

module Queries
  class CommentsQuery < Queries::BaseQuery
    argument :comment_object_type, String, required: true
    argument :comment_object_id, Int, required: true

    type [Types::CommentType], null: false

    def resolve(comment_object_type:, comment_object_id:)
      Comment.where(
        comment_object_type:,
        comment_object_id:,
        parent_comment_id: nil
      )
    end
  end

  class CountCommentsQuery < Queries::BaseQuery
    argument :comment_object_type, String, required: true
    argument :comment_object_id, Int, required: true

    type Integer, null: false

    def resolve(comment_object_type:, comment_object_id:)
      Comment.where(comment_object_type:, comment_object_id:).count
    end
  end
end
