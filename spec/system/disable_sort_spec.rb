# frozen_string_literal: true

describe "Disabling topic list sorting", type: :system do
  fab!(:category)
  let(:category_page) { PageObjects::Pages::Category.new }

  before do
    SiteSetting.calendar_enabled = true
    Fabricate.times(2, :topic, category:)
  end

  it "disables the ability to sort topic list columns" do
    category_page.visit(category)
    expect(find("th.activity")).to match_selector(".sortable")

    category.custom_fields["disable_topic_resorting"] = true
    category.save!
    page.refresh
    expect(find("th.activity")).to match_selector(".sortable")

    SiteSetting.disable_resorting_on_categories_enabled = true
    page.refresh
    expect(find("th.activity")).to_not match_selector(".sortable")
  end

  # TODO: cvx - remove after the glimmer topic list transition
  context "when glimmer topic list is enabled" do
    fab!(:user)

    before do
      SiteSetting.experimental_glimmer_topic_list_groups = Group::AUTO_GROUPS[:everyone]
      sign_in(user)
    end

    it "disables the ability to sort topic list columns" do
      category_page.visit(category)
      expect(find("th.activity")).to match_selector(".sortable")

      category.custom_fields["disable_topic_resorting"] = true
      category.save!
      page.refresh
      expect(find("th.activity")).to match_selector(".sortable")

      SiteSetting.disable_resorting_on_categories_enabled = true
      page.refresh
      expect(find("th.activity")).to_not match_selector(".sortable")
    end
  end
end