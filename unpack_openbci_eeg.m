%
% Function that unpacks the eeg samples from the openbci packets
%
function [ eeg_data, packet_numbers] = unpack_openbci_eeg( packet, nb_packets )

openbci_constants;

% initialize output buffers
eeg_data = zeros(nb_packets,NB_CHANNELS);
packet_numbers = zeros(nb_packets,1);

for ii=1:nb_packets

    offset = (ii-1)*DATA_PACKET_LENGTH;

    % check if the first byte correspond to the
    % standard
    if packet(1+offset) ~= PACKET_FIRST_WORD

        % show the packet for debuggin purpose
        packet
        warning('Invalid packet format');
        return;
    end
    
    % save the packet number
    packet_numbers(ii) = packet(2+offset);
    
    % extract eeg samples (24 bits) and interpret them as signed integer 32
    eeg_data(ii,1) = int24_to_int32(packet((3:5)+offset));
    eeg_data(ii,2) = int24_to_int32(packet((6:8)+offset));
    eeg_data(ii,3) = int24_to_int32(packet((9:11)+offset));
    eeg_data(ii,4) = int24_to_int32(packet((12:14)+offset));
    eeg_data(ii,5) = int24_to_int32(packet((15:17)+offset));
    eeg_data(ii,6) = int24_to_int32(packet((18:20)+offset));
    eeg_data(ii,7) = int24_to_int32(packet((21:23)+offset));
    eeg_data(ii,8) = int24_to_int32(packet((24:26)+offset));
end

end