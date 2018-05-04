require 'test_helper'

class PostTest < ActiveSupport::TestCase
  test 'can be soft-deleted with an attachment' do
    post = Post.create!
    File.open(__FILE__, 'r') do |test_file|
      post.file.attach io: test_file, filename: File.basename(__FILE__)
    end
    post.destroy!
    assert post.file.attached?
    assert post.file.download.present?
  end

  test 'can be recovered with an attachment' do
    post = Post.create!(deleted_at: Time.now.utc)
    File.open(__FILE__, 'r') do |test_file|
      post.file.attach io: test_file, filename: File.basename(__FILE__)
    end
    post.recover
    post.reload
    assert post.file.attached?
    assert post.file.download.present?
  end

  test 'can really delete with an attachment' do
    post = Post.create!
    File.open(__FILE__, 'r') do |test_file|
      post.file.attach io: test_file, filename: File.basename(__FILE__)
    end
    post.destroy_fully!
    assert_equal 0, ActiveStorage::Attachment.count
    assert_equal 0, ActiveStorage::Blob.count
  end
end
