require "test_helper"

class NoteTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    note = Note.new(
      title: "Moja notatka",
      content: "Treść notatki",
      user: users(:regular_user)
    )
    assert note.valid?
  end

  test "should not be valid without title" do
    note = Note.new(
      content: "Treść notatki",
      user: users(:regular_user)
    )
    assert_not note.valid?
    assert_includes note.errors[:title], "nie może być puste"
  end

  test "should not be valid without content" do
    note = Note.new(
      title: "Tytuł",
      user: users(:regular_user)
    )
    assert_not note.valid?
    assert_includes note.errors[:content], "nie może być puste"
  end

  test "should not be valid without user" do
    note = Note.new(
      title: "Tytuł",
      content: "Treść"
    )
    assert_not note.valid?
    # Dla belongs_to lepiej sprawdzić obecność błędu niż konkretny komunikat
    assert note.errors[:user].present?
  end

  test "should load note from fixtures" do
    note = notes(:one)
    assert note.valid?
    assert_equal "Pierwsza notatka", note.title
    assert_equal "Treść pierwszej notatki", note.content
  end

  test "should belong to user" do
    note = notes(:one)
    assert_instance_of User, note.user
  end
end