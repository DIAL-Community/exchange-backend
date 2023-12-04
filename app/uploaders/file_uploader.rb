# frozen_string_literal: true

class FileUploader < CarrierWave::Uploader::Base
  after :store, :send_notification
  storage :file

  attr_reader :filename

  def initialize(_model, file_name, current_user)
    super(model, nil)
    @file_name = file_name
    @current_user = current_user
  end

  def current_filename
    @filename
  end

  def store_dir
    Rails.root.join('public', 'assets', 'resources')
  end

  def extension_allowlist
    %w[pdf doc docx ppt pptx xls xlsx]
  end

  def content_type_allowlist
    %w[
      application/pdf
      application/msword
      application/vnd.openxmlformats-officedocument.wordprocessingml.document
      application/vnd.ms-powerpoint
      application/vnd.openxmlformats-officedocument.presentationml.presentation
      application/vnd.ms-excel
      application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
    ]
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
