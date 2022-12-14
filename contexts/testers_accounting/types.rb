# frozen_string_literal: true

module TestersAccounting
  module Types
    include Dry.Types()

    Id = Params::Integer.constrained(gt: 0)

    # Types for inspection
    InspectionStatus = String.default("pending").enum("pending", "ready")

    InspectionCharacteristicType = String.enum("happiness", "playful", "safeties", "brightness")
    InspectionCharacteristicValue = String.constrained(format: /\A[a-z0-9]{8}\z/i)
    InspectionCharacteristic = Types::Hash.schema(
      characteristic_type: InspectionCharacteristicType,
      value: InspectionCharacteristicValue,
      comment?: String,
      will_recommend: Bool.default(true)
    )
    InspectionCharacteristics = Array.of(InspectionCharacteristic)
  end
end
