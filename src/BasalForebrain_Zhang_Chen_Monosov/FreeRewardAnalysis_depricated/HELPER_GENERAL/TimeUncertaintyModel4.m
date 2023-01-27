%DEMO OF UNCERTAINTY AND TIME
%Ilya E Monosov 2015
clear all; clc; close all;

var1=std([4.5 1.5 1.5 1.5])%./mean([4.5 1.5 1.5 1.5]);
var2=std([1.5 1.5 4.5 4.5])%./mean([1.5 1.5 4.5 4.5]);
var3=std([1.5 4.5 4.5 4.5])%./mean([1.5 4.5 4.5 4.5]);
var4=0;

var1value=mean([.6 1 1 1])%./mean([4.5 1.5 1.5 1.5]);
var2value=mean([1 1 0.6 0.6])%./mean([1.5 4.5 4.5 4.5]);
var3value=mean([1 .6 .6 .6])%./mean([1.5 4.5 4.5 4.5]);
var4value=1;

risk1=std([.6 1 1 1])./mean([.6 1 1 1])
risk2=std([1 1 0.6 0.6])./mean([1 1 0.6 0.6])
risk3=std([1 .6 .6 .6])./mean([1 .6 .6 .6])
risk4=1;

var1=var1./risk1
var2=var2./risk2
var3=var3./risk3
var4=var4./risk4

n=1500; 
x= linspace(0,1500, n); % Adapt n for resolution of graph
%
subplot(1,2,1)
y= (var4*x)+var4value;
plot(x,y,'k'); hold on
%
y= (var1*x)+var1value;
plot(x,y,'r'); hold on
%
y= (var2*x)+var2value;
plot(x,y,'g'); hold on
%
y= (var3*x)+var3value;
plot(x,y,'b'); hold on
%
temporalperceptinterval=500% just a guessed temporal interval monkey can estimate well
xlim([0 1500/temporalperceptinterval])
%
legend('6304','6303','6302','6301','Location','northwest')



%temporal dispersion
var1=std([10 1.5 1.5 1.5])./mean([10 1.5 1.5 1.5]);
var2=std([1.5 1.5 10 10])./mean([1.5 1.5 10 10]);
var3=std([1.5 10 10 10])./mean([1.5 10 10 10]);
var4=0;

%for now just binary subjective value variable
var1value=mean([0 1 1 1])%./mean([4.5 1.5 1.5 1.5]);
var2value=mean([1 1 0 0])%./mean([1.5 4.5 4.5 4.5]);
var3value=mean([1 0 0 0])%./mean([1.5 4.5 4.5 4.5]);
var4value=1;


subplot(1,2,2)
y= (var4*x)+var4value;
%y= fliplr(1./(var4*x))+var4value;
plot(x,y,'k'); hold on
%
%y= fliplr(1./(var1*x))+var1value;
y= (var1*x)+var1value;
plot(x,y,'r'); hold on
%
y= (var2*x)+var2value;
%y= fliplr(1./(var2*x))+var2value;
plot(x,y,'g'); hold on
%
%y= fliplr(1./(var3*x))+var3value;
y= (var3*x)+var3value;
plot(x,y,'b'); hold on
%
xlim([0 1500/temporalperceptinterval])



warning on;


