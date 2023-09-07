%% Instrument Connection

close all; clear all

% Find a udp object.
obj1 = instrfind('Type', 'udp', 'RemoteHost', '192.168.1.4', 'RemotePort', 10, 'Tag', '');

% Create the udsp object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = udp('192.168.1.4', 10); %occorre fissare IP statico (da impostazioni del router domestico)
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Configure instrument object, obj1.
set(obj1, 'LocalPort', 22);
set(obj1, 'LocalPortMode', 'manual');

% Connect to instrument object, obj1.
fopen(obj1);

%% read data from obj1
i=1;
while i<10001
    data = fscanf(obj1, '%s'); %get string via UDP
    num_data(i) = str2double(data); %convert to double
    plot(num_data)
    grid on
    pause(0.0001)
    i=i+1;
end

%write data
%dataWrite = fprintf(obj1, 'ciao');