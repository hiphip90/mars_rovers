require_relative '../lib/mission_control'
require_relative '../lib/rover'
require_relative '../lib/rover/factory'

describe MissionControl do
  let(:rover_factory) { double(Rover::Factory) }
  let(:mission_control) { MissionControl.new }
  let(:rover) { double(Rover, id: 1, x: 0, y: 0) }
  let(:other_rover) { double(Rover, id: 2, x: 1, y: 0) }

  before do
    mission_control.rover_factory = rover_factory
  end

  describe('.new') do
    it 'sets next_id' do
      expect(mission_control.next_id).to eq 1
    end

    it 'sets rovers array' do
      expect(mission_control.rovers).to eq []
    end

    it 'sets rover_factory' do
      expect(mission_control.rover_factory).to eq rover_factory
    end
  end

  context 'instance methods' do
    before do
      mission_control.rovers << rover << other_rover
    end

    describe '#deploy_new_rover' do
      let(:new_rover) { double(Rover, id: 5, x: 2, y: 0) }

      before do
        allow(new_rover).to receive(:report_position)
        allow(rover_factory).to(receive(:fabricate_rover).with(5, 2, 0).
                                  and_return(new_rover))
        mission_control.next_id = 5
      end

      it 'calls rover factory with a value of next_id and coordinates of a first empty tile of the first row of the field' do
        expect(rover_factory).to(receive(:fabricate_rover).with(5, 2, 0).
                                   and_return(new_rover))

        mission_control.deploy_new_rover
      end

      it 'increases next_id by 1' do
        expect { mission_control.deploy_new_rover }.to change(mission_control, :next_id).by(1)
      end

      it 'adds new rover to array of known rovers' do
        mission_control.deploy_new_rover
        expect(mission_control.rovers).to include(new_rover)
      end
    end

    describe('#open_comm_channel_with_rover') do
      it 'returns rover with given id' do
        expect(mission_control.open_comm_channel_with_rover(1)).to eq rover
      end

      it 'returns nil if rover with given id does not exist' do
        expect(mission_control.open_comm_channel_with_rover(3)).to eq nil
      end
    end

    describe('#send_command_to_rover') do
      it 'calls #receive on rover with given id passing it command' do
        command = 'LMR'

        expect(rover).to receive(:receive).with(command)
        mission_control.send_command_to_rover(1, command)
      end
    end

    describe('#report_rover_manual') do
      it 'calls #report_manual on rover with given id' do
        expect(rover).to receive(:report_manual)
        mission_control.report_rover_manual(1)
      end
    end

    describe('#report_rover_position') do
      it 'calls #report_position on rover with given id' do
        expect(rover).to receive(:report_position)
        mission_control.report_rover_position(1)
      end
    end

    describe('#tile_free?') do
      it 'returns false if x is less then 0' do
        expect(mission_control.tile_free?(-1, 0)).to be_falsey
      end

      it 'returns false if y is less then 0' do
        expect(mission_control.tile_free?(0, -1)).to be_falsey
      end

      it 'returns false if x and y is less then 0' do
        expect(mission_control.tile_free?(-1, -1)).to be_falsey
      end

      context 'when provided with id of current rover' do
        it 'returns true if no rover occupies tile' do
          expect(mission_control.tile_free?(2, 0, 1)).to be_truthy
        end

        it 'returns false if other rover occupies tile' do
          expect(mission_control.tile_free?(1, 0, 1)).to be_falsey
        end

        it 'returns true if rover with given id occupies tile' do
          expect(mission_control.tile_free?(0, 0, 1)).to be_truthy
        end
      end

      context 'when not provided with id of current rover' do
        it 'returns true if no rover occupies tile' do
          expect(mission_control.tile_free?(2, 0)).to be_truthy
        end

        it 'returns false if some rover occupies tile' do
          expect(mission_control.tile_free?(1, 0)).to be_falsey
        end
      end
    end
  end
end
