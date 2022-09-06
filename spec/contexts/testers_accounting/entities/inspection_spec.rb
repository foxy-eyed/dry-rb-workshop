# frozen_string_literal: true

RSpec.describe TestersAccounting::Entities::Inspection do
  let(:inspection) { described_class.new(payload) }
  let(:payload) { { id: 1, account_id: 2, cat_toy_id: 3, status: "pending" } }

  it "builds correct object" do
    expect(inspection.id).to eq(1)
    expect(inspection.status).to eq("pending")
  end

  describe "#discarded?" do
    context "when pending" do
      it "returns false" do
        expect(inspection).not_to be_discarded
      end
    end

    context "with status ready and empty characteristics" do
      let(:payload) { { id: 1, account_id: 2, cat_toy_id: 3, status: "ready" } }

      it "returns true" do
        expect(inspection).to be_discarded
      end
    end

    context "with status ready and valid characteristics" do
      let(:payload) do
        {
          id: 1, account_id: 2, cat_toy_id: 3, status: "ready", characteristics: [{
            characteristic_type: "brightness", value: "87654321", will_recommend: true
          }]
        }
      end

      it "returns false" do
        expect(inspection).not_to be_discarded
      end
    end
  end
end
