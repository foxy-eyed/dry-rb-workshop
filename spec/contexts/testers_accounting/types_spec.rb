# frozen_string_literal: true

RSpec.describe TestersAccounting::Types do
  describe "Id" do
    let(:type) { TestersAccounting::Types::Id }

    context "when positive integer" do
      it { expect(type[1]).to eq(1) }
    end

    context "when zero" do
      it { expect { type[0] }.to raise_error(Dry::Types::ConstraintError) }
    end

    context "when negative integer" do
      it { expect { type[-1] }.to raise_error(Dry::Types::ConstraintError) }
    end

    context "when coercible string" do
      it { expect(type["1"]).to eq(1) }
    end
  end

  describe "InspectionStatus" do
    let(:type) { TestersAccounting::Types::InspectionStatus }

    context "when empty" do
      it "uses default" do
        expect(type[]).to eq("pending")
      end
    end

    context "when valid" do
      it { expect(type["pending"]).to eq("pending") }

      it { expect(type["ready"]).to eq("ready") }
    end

    context "when invalid" do
      it { expect { type["unknown"] }.to raise_error(Dry::Types::ConstraintError) }
    end
  end

  describe "InspectionCharacteristicType" do
    let(:type) { TestersAccounting::Types::InspectionCharacteristicType }

    context "when valid" do
      it "returns value" do
        %w[happiness playful safeties brightness].each do |type_value|
          expect(type[type_value]).to eq(type_value)
        end
      end
    end

    context "when invalid" do
      it { expect { type["unknown"] }.to raise_error(Dry::Types::ConstraintError) }
    end
  end

  describe "InspectionCharacteristic" do
    let(:type) { TestersAccounting::Types::InspectionCharacteristic }

    context "when valid" do
      let(:value) do
        {
          characteristic_type: "happiness",
          value: "12345678",
          will_recommend: true
        }
      end

      it { expect(type[value]).to eq(value) }
    end

    context "when invalid" do
      let(:value) do
        {
          characteristic_type: "unknown",
          some_invalid_key: "12345678"
        }
      end

      it { expect { type[value] }.to raise_error(Dry::Types::SchemaError) }
    end
  end
end
