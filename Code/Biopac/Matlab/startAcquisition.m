function retval = startAcquisition(dothdir, libname,mptype, mpmethod, sn)
    %% Connect
    fprintf(1,'Connecting...\n');

    [retval, sn] = calllib(libname,'connectMPDev',mptype,mpmethod,sn);

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Connect.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end

    fprintf(1,'Connected\n');

    %% Configure
    fprintf(1,'Setting Sample Rate to 200 Hz\n');
    retval = calllib(libname, 'setSampleRate', 5.0);

    if ~strcmp(retval,'MPSUCCESS')
       fprintf(1,'Failed to Set Sample Rate.\n');
       calllib(libname, 'disconnectMPDev');
       return
    end

    fprintf(1,'Sample Rate Set\n');
    
    
    %% set acquisition channels
    fprintf(1,'Setting to Acquire on Channels 1 and 2');

    aCH = [int32(1),int32(1),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0),int32(0)];
    
    % if mptype is not MP150
    if mptype ~= 101
        %then it must be the mp35 (102) or mp36 (103)
        aCH = [int32(1),int32(1),int32(0),int32(0)];
    end
    
    [retval, aCH] = calllib(libname, 'setAcqChannels',aCH);

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Set Acq Channels.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    fprintf(1,'Channels Set\n');

    %% start to acquire
    fprintf(1,'Start Acquisition Daemon\n');
    
    retval = calllib(libname, 'startMPAcqDaemon');
  
    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Start Acquisition Daemon.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    fprintf(1,'Start Acquisition\n');

    retval = calllib(libname, 'startAcquisition');

    if ~strcmp(retval,'MPSUCCESS')
        fprintf(1,'Failed to Start Acquisition.\n');
        calllib(libname, 'disconnectMPDev');
        return
    end
    
    %% Download and Plot 5000 samples in realtime
    fprintf(1,'Download and Plot 5000 samples in Real-Time\n');
    numRead = 0;
    numValuesToRead = 200*2; %collect 1 second worth of data points per iteration
    remaining = 5000*2; %collect 5000 samples per channel
    tbuff(1:numValuesToRead) = double(0); %initialize the correct amount of data
    bval = 0;
    offset = 1;
    
    % create new figure
    figure;
    
    %loop until there still some data to acquire
    while(remaining > 0)
       
       if numValuesToRead > remaining
               numValuesToRead = remaining;
       end
       
       [retval, tbuff, numRead]  = calllib(libname, 'receiveMPData',tbuff, numValuesToRead, numRead);
       
       if ~strcmp(retval,'MPSUCCESS')
           fprintf(1,'Failed to receive MP data.\n');
           calllib(libname, 'disconnectMPDev');
           return
       else
            buff(offset:offset+double(numRead(1))-1) = tbuff(1:double(numRead(1))); 
            
            %% Process
            len = length(buff);
            ch1data = buff(1:2:len);
            ch2data = buff(2:2:len);
            %ch3data = buff(3:3:len);
            X(1:len) = (1:len);
            %% plot graph
            pause(1/100);
            subplot(2,1,1);
            plot(X(1:length(ch1data)),ch1data,'g-');
            title('Data Plot of for Channel 1 and 2');
            subplot(2,1,2);
            plot(X(1:length(ch2data)),ch2data,'b-');
            %subplot(3,1,3);
            %plot(X(1:length(ch3data)),ch3data,'r-');
            xlabel('Nth Sample');
       end
       offset = offset + double(numValuesToRead);
       remaining = remaining-double(numValuesToRead);
   end
   
   %% stop acquisition
   fprintf(1,'Stop Acquisition\n');

   retval = calllib(libname, 'stopAcquisition');
   if ~strcmp(retval,'MPSUCCESS')
       fprintf(1,'Failed to Stop\n');
       calllib(libname, 'disconnectMPDev');
       return
   end
    
   %% disconnect
   fprintf(1,'Disconnecting...\n')
   retval = calllib(libname, 'disconnectMPDev');
end