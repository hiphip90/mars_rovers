require_relative '../lib/rover'
require_relative '../lib/rover/control_unit'

describe Rover do
  let(:rover) { Rover.new(1, 2, 3) }
  let(:control_unit) { double(Rover::ControlUnit) }

  before do
    rover.control_unit = control_unit
  end

  describe('.new') do
    it 'sets id' do
      expect(rover.id).to eq 1
    end

    it 'sets x coordinate' do
      expect(rover.x).to eq 2
    end

    it 'sets y coordinate' do
      expect(rover.y).to eq 3
    end

    it 'sets default heading' do
      expect(rover.heading).to eq 'N'
    end
  end

  describe('#receive') do
    it 'delegates to #execute_command of control unit' do
      command = 'RRMLL'

      expect(control_unit).to receive(:execute_command).with(command)

      rover.receive(command)
    end
  end

  describe('#report_manual') do
    it 'delegates to #report_manual of control unit' do
      expect(control_unit).to receive(:report_manual)

      rover.report_manual
    end
  end

  describe('#report_manual') do
    it 'delegates to #report_manual of control unit' do
      expect(control_unit).to receive(:report_manual)

      rover.report_manual
    end
  end
end
