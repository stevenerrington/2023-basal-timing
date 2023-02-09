function datafile_format;

%******** datafile_format:
%*** simply provides information on datafile format of the
%*** sample files provided under 'datafiles' directory.
%***
%****** data.label(nChannels) = {'SU1' ; 'MU1'; 'LFP1'; 'EYE1'};
%****** data.trials{ntrials} = [[Su1 data 1:T];[Mu1 data from 1:T];...];
%****** data.spontaneous{ntrials} = [Su1 data 1:250ms]; %spike data only,
%******                % data from interval when fixation first occurs
%******                % and before the stimuli first onset
%****** data.time{ntrials} = [1:T]
%****** data.attend(ntrials) = 1 if attended in RF, 2 is 2 of 4 unatt, 3 is
%******                             for the 1 of 4 unattended case
%****** data.exactspikes{ntrials} = exact single unit spike times per
%******                              per trial to 0.025 ms precision
%****** data.fsample = 1000;
%****** data.sustained = XA:XB  % to mark the 800 ms sustained period
%****** data.morepause = -250 to +250 after 1000ms pause, 1500 ms
%****** data.pause = exact period of 1000ms pause
%****** data.surround = -950 to -450 ms before pause, stimuli are outside
%******                   the RF (period of non-visual response?)
%****** data.waveform = [1:32];
%****** data.isolation = 1 - well isolated single unit, 
%******                  2 - clear cluster but some overlap
%******                  3 - multi-unit, large overlap
%******                  4 - well isolated, but lost midway in session
%********
%********

disp('   ');
disp('This routine does nothing, but its comments have');
disp('information on the datafile format ... type instead');
disp('  >> help datafile_format');
disp('   ');

return;

