# frozen_string_literal: true

module Modules
  module Slugger
    def slug_em(input, max_length = 32)
      slug = input
             .split(/\s+/)
             .map { |part| part.gsub(/[^A-Za-z0-9]/, '').downcase }
             .join('_')
      slug = slug.slice(0, max_length) if slug.length > max_length
      slug = slug.chop if slug[-1] == '_'
      slug
    end

    def reslug_em(input, max_length = 64)
      slug = input
             .split(/\s+/)
             .map { |part| part.gsub(/[^A-Za-z0-9]/, '').downcase }
             .join('-')
      slug = slug.slice(0, max_length) if slug.length > max_length
      slug = slug.chop if slug[-1] == '-'
      slug
    end

    def generate_offset(first_duplicate)
      size = 0
      if !first_duplicate.nil? && first_duplicate.slug.include?('-duplicate-')
        size = first_duplicate.slug
                              .slice(/\-duplicate\-\d+$/)
                              .delete('^0-9')
                              .to_i + 1
      end
      "-duplicate-#{size}"
    end
  end
end
