% This runs through some of the available analysis
% routines one by one for demonstration on one single
% unit example.  Each routine should produce a set of
% data plots

unit_example = 'mnar4_u2';  % narrow spiking unit
%******** you might try some other units as well
% unit_example = 'msir27_u3';  % narrow spiking unit
% unit_example = 'mzir50_u1';  % broad burst spiking unit

disp('   ');
disp('First, print out datafile format just to know its there');
input('Press return to continue');
help datafile_format;

%*****************************************************
disp('  ');
disp('Ready to run following command:');
disp('   ax = basic_neuron_info(unit_example,[],1)');
disp('  ');
input('Press return to continue');
ax = basic_neuron_info(unit_example,[],1);
%******* the above routine interpolated mean spike waveform
%**** and computes spontaneous and visually evoked rates

%*****************************************************
disp('  ');
disp('Ready to run following command:');
disp('   bx = rate_fano_factor_psth(unit_example,[],1)');
disp('  ');
input('Press return to continue');
bx = rate_fano_factor_psth(unit_example,[],1);
%******* the above routine computes firing rate and 
%******* Fano Factor as function of counting intervals

%*****************************************************
disp('  ');
disp('Ready to run following command:');
disp('   cx = rate_normalized_autocor_power(unit_example,[],1)');
disp('  ');
input('Press return to continue');
cx = rate_normalized_autocor_power(unit_example,[],[],1);
%******* the above routine computes the autocorrelation and
%******* the power spectrum of spike trains

%*****************************************************
disp('  ');
disp('Ready to run following command:');
disp('   dx = rate_normalized_coherence(unit_example,LFP1,[],100,1)');
disp('  ');
input('Press return to continue');
dx = rate_normalized_coherence(unit_example,'LFP1',[],100,1);
%******* the above routine computes the autocorrelation and
%******* the power spectrum of spike trains
