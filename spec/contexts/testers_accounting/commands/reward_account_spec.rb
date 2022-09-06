# frozen_string_literal: true

RSpec.describe TestersAccounting::Commands::RewardAccount do
  let(:command) { described_class.new(account_repo: account_repo, inspection_repo: inspection_repo) }

  let(:account_repo) do
    instance_double(TestersAccounting::Repositories::Account, find: account, reward!: account)
  end
  let(:inspection_repo) do
    instance_double(TestersAccounting::Repositories::Inspection, completed_by_account: inspection_result)
  end

  context "when everything is OK" do
    let(:account) do
      TestersAccounting::Entities::Account.new(id: 1, name: "Ivan", email: "ivan@test.com", blocked: false, score: 0)
    end
    let(:inspection_result) do
      [
        TestersAccounting::Entities::Inspection.new(
          id: 1, account_id: 1, cat_toy_id: 1, status: "ready",
          characteristics: [{ characteristic_type: "brightness", value: "87654321", will_recommend: true }]
        ),
        TestersAccounting::Entities::Inspection.new(
          id: 2, account_id: 1, cat_toy_id: 2, status: "ready",
          characteristics: [{ characteristic_type: "happiness", value: "12345678", will_recommend: false }]
        )
      ]
    end

    it "returns success" do
      result = command.call(1)
      expect(result).to be_success
      expect(result.value!).to eq(account)
    end

    it "rewards account" do
      allow(account_repo).to receive(:reward!)
      command.call(1)
      expect(account_repo).to have_received(:reward!).with(id: account.id, score: 2000)
    end
  end

  context "when account does not exist" do
    let(:account) { nil }
    let(:inspection_result) { [] }

    it "fails" do
      result = command.call(1)
      expect(result).to be_failure
      expect(result.failure).to eq([:account_not_found, { account_id: 1 }])
    end
  end

  context "when account is blocked" do
    let(:account) do
      TestersAccounting::Entities::Account.new(id: 1, name: "Ivan", email: "ivan@test.com", blocked: true, score: 0)
    end
    let(:inspection_result) { [] }

    it "fails" do
      result = command.call(1)
      expect(result).to be_failure
      expect(result.failure).to eq([:account_is_blocked, { account_id: 1 }])
    end
  end

  context "when account has invalid inspections" do
    let(:account) do
      TestersAccounting::Entities::Account.new(id: 1, name: "Ivan", email: "ivan@test.com", blocked: false, score: 0)
    end
    let(:inspection_result) do
      [
        TestersAccounting::Entities::Inspection.new(id: 1, account_id: 1, cat_toy_id: 1, status: "ready"),
        TestersAccounting::Entities::Inspection.new(
          id: 2, account_id: 1, cat_toy_id: 2, status: "ready",
          characteristics: [{ characteristic_type: "happiness", value: "12345678", will_recommend: false }]
        )
      ]
    end

    it "fails" do
      result = command.call(1)
      expect(result).to be_failure
      expect(result.failure).to eq([:account_has_bad_tests, { account: account }])
    end
  end

  context "with real objects" do
    let(:command) { described_class.new }
    let(:db) { Container["persistence.db"] }

    before do
      # prepare data
      account_id = db[:accounts].insert(name: "Ivan", email: "ivan@mail.ru")
      cat_toy_id = db[:cat_toys].insert(name: "Crazy fish")
      db[:inspections].insert(
        account_id: account_id,
        cat_toy_id: cat_toy_id,
        status: "ready",
        characteristics: [{ characteristic_type: "brightness", value: "87654321", will_recommend: true }].to_json
      )
    end

    after do
      # drop data
      db[:inspections].delete
      db[:accounts].delete
      db[:cat_toys].delete
    end

    it "works" do
      account_id = db[:accounts].select(:id).order(:id).last[:id]
      result = command.call(account_id)
      account = TestersAccounting::Entities::Account.new(db[:accounts].where(id: account_id).first)

      expect(result).to be_success
      expect(result.value!).to eq(account)
      expect(account.score).to eq(1000)
    end
  end
end
