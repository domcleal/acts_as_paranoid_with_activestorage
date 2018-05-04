# Test case for acts_as_paranoid + ActiveStorage

Run `rails test` and see test/models/post_test.rb for the expected
behaviour for deleting models using acts_as_paranoid with an attachment
in ActiveStorage.

On `destroy!` you currently get:

    SystemStackError: stack level too deep
        test/models/post_test.rb:9:in `block in <class:PostTest>'

As there's a loop of some sort between callbacks during the soft delete.

If the ActiveStorage attachment is given the `dependent: false` option
then it fixes the stack error, but then loses the
ActiveStorage::Attachment association during the soft delete (while the
blob remains as it's no longer purged). Ideally, the Attachment would
remain until really deleted.
