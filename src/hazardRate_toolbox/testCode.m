pdf_1 = [ 2  4  7 11 16 22 16 11 7  4  2 ];
pdf_2 = [ 2 5 10 5  2  0  2  5 10  5  2 ];

tStep_val = 100:100:1100;
timeRes = 50;

eventProb = 1;
WeberFactor = 0.26;

figure; 
hazF_subjective_1 = hazardF_subjective(pdf_1, tStep_val, eventProb, WeberFactor, timeRes)
plot( tStep_val , hazF_subjective_1 , 'r-' ); hold on

hazF_subjective_2 = hazardF_subjective(pdf_2, tStep_val, eventProb, WeberFactor, timeRes)
plot( tStep_val , hazF_subjective_2 , 'b-' ); hold on