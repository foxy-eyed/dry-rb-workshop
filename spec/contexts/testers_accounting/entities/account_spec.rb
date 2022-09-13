# frozen_string_literal: true

RSpec.describe TestersAccounting::Entities::Account do
  let(:account) { described_class.new(payload) }
  let(:payload) { { id: 1, blocked: blocked, score: 0 } }
  let(:blocked) { false }

  it "builds correct object" do
    expect(account.id).to eq(1)
    expect(account.score).to eq(0)
  end

  describe "#blocked?" do
    context "when non-blocked" do
      it "returns false" do
        expect(account).not_to be_blocked
      end
    end

    context "when blocked" do
      let(:blocked) { true }

      it "returns true" do
        expect(account).to be_blocked
      end
    end
  end
end
