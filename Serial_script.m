%% Instrument Connection

% Find a serial port object.
obj1 = instrfind('Type', 'serial', 'Port', 'COM3', 'Tag', '');

% Create the serial port object if it does not exist
% otherwise use the object that was found.
if isempty(obj1)
    obj1 = serial('COM3');
else
    fclose(obj1);
    obj1 = obj1(1);
end

% Connect to instrument object, obj1.
fopen(obj1);

%% read data from obj1
i=1;
while i<10001
    data = fscanf(obj1, '%s'); %get string via UDP
    num_data(i) = str2double(data); %convert to double
    plot(num_data)
    grid on
    pause(0.001)
    i=i+1;
end
