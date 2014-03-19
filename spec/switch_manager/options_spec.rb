require 'switch_manager/options'

describe SwitchManager::Options do
  describe '#parse' do
    When(:result) do
      SwitchManager::Options.new.parse(%w(-p 1234))
    end

    Then { result[:port] == 1234 }
  end
end
