# frozen_string_literal: true

module TestersAccounting
  module Types
    include Dry.Types()

    # Types for inspection
    InspectionStatus = String.default("pending").enum("pending", "ready")

    InspectionCharacteristicType = String.enum("happiness", "playful", "safeties", "brightness")
    InspectionCharacteristicValue = String.constrained(format: /\A[a-z0-9]{8}\z/i)
    InspectionCharacteristic = Types::Hash.schema(
      characteristic_type: InspectionCharacteristicType,
      value: InspectionCharacteristicValue,
      comment: String.optional,
      will_recommend: Bool
    )
    InspectionCharacteristics = Array.of(InspectionCharacteristic)
  end
end
