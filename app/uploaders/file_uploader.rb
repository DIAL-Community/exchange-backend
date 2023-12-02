# frozen_string_literal: true

class FileUploader < CarrierWave::Uploader::Base
  after :store, :send_notification
  storage :file

  attr_reader :filename

  def initialize(file_name, current_user)
    super()
    @file_name = file_name
    @current_user = current_user
  end

  def current_filename
    @filename
  end

  def store_dir
    Rails.root.join('public', 'assets', 'entities')
  end

  def extension_allowlist
    %w[pdf]
  end

  def content_type_allowlist
    %w[application/pdf]
  end

  def send_notification(file)
    EntityUploadMailer
      .with(
        user: @current_user,
        filename: file.original_filename
      )
      .notify_upload
      .deliver_later
  end
end
