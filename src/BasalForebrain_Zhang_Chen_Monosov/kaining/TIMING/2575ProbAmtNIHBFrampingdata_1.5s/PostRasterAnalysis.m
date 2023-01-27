    RangeEarly=200;
    
temp=SDFcs_n([completedtrial],5500:6500);
temp1=repmat([1:1001],size(temp,1),1);
[Pval,Rval]=permutation_pair_test_fast(temp(:),temp1(:),NumberofPermutations,'corr')
savestruct(xzv).P_ramp=Pval;
savestruct(xzv).R_ramp=Rval;


temp=SDFcs_n(completedtrialAmt,5000-1000:6500);
Amt_=nanmean(temp);
temp=SDFcs_n(completedtrialProb,5000-1000:6500);
Prob_=nanmean(temp);
Amt_=(Amt_-nanmean(Amt_(1:1000)))
Prob_=(Prob_-nanmean(Prob_(1:1000)))
savestruct(xzv).Amt_=Amt_;
savestruct(xzv).Prob_=Prob_;

Amt_=smooth(Amt_(1000:end),100)';
Prob_=smooth(Prob_(1000:end),100)';

All_=[Amt_'; [NaN NaN NaN]'; Prob_';]
All_=All_-min(All_)
All_=All_./max(All_)
savestruct(xzv).All_=All_;
%plot(All_)
close all




    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [R,p]=(rocarea3(SDFcs_n(find(prob0==1),5000:6500), SDFcs_n(find(prob100==1),5000:6500)))
    savestruct(xzv).ROC_value=R;
    savestruct(xzv).ROC_valueP=p;

    [R,p]=(rocarea3(SDFcs_n([find(prob100==1); find(prob0==1)],5000:6500), SDFcs_n(find(prob50==1),5000:6500)))
    savestruct(xzv).ROC_unc=R;
    savestruct(xzv).ROC_uncP=p;
    
    savestruct(xzv).AverageFiringRate=nanmean(nanmean(SDFcs_n(:,3000:3500)));
    
    %first 250ms

    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(prob100,1500:1500+RangeEarly)')';
    t2=nansum(Rasters(prob75,1500:1500+RangeEarly)')';
    t3=nansum(Rasters(prob50,1500:1500+RangeEarly)')';
    t4=nansum(Rasters(prob25,1500:1500+RangeEarly)')';
    t5=nansum(Rasters(prob0,1500:1500+RangeEarly)')';
    
    [r,p]= rocarea3(t1,t3)
    savestruct(xzv).seROC_uncP=p;
    savestruct(xzv).seROC_unc=r;
    
    [r,p]= rocarea3(t5,t1)
    savestruct(xzv).sevROC_uncP=p;
    savestruct(xzv).sevROC_unc=r;
          
            
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(prob100,1500:1500+RangeEarly)')';
    t2=nansum(Rasters(prob75,1500:1500+RangeEarly)')';
    t3=nansum(Rasters(prob50,1500:1500+RangeEarly)')';
    t4=nansum(Rasters(prob25,1500:1500+RangeEarly)')';
    t5=nansum(Rasters(prob0,1500:1500+RangeEarly)')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    savestruct(xzv).Pvalfirst250=Pval;
    savestruct(xzv).Rvalfirst250=Rval;
    savestruct(xzv).Puncfirst250=Punc;
    savestruct(xzv).Runcfirst250=Runc;
    
    
    %last 250ms
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(prob100,3000-RangeEarly:3000)')';
    t2=nansum(Rasters(prob75,3000-RangeEarly:3000)')';
    t3=nansum(Rasters(prob50,3000-RangeEarly:3000)')';
    t4=nansum(Rasters(prob25,3000-RangeEarly:3000)')';
    t5=nansum(Rasters(prob0,3000-RangeEarly:3000)')';
    
        
    [r,p]= rocarea3(t1,t3)
    savestruct(xzv).selROC_uncP=p;
    savestruct(xzv).selROC_unc=r;
    
    [r,p]= rocarea3(t5,t1)
    savestruct(xzv).sevlROC_uncP=p;
    savestruct(xzv).sevlROC_unc=r;
    
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(prob100,3000-RangeEarly:3000)')';
    t2=nansum(Rasters(prob75,3000-RangeEarly:3000)')';
    t3=nansum(Rasters(prob50,3000-RangeEarly:3000)')';
    t4=nansum(Rasters(prob25,3000-RangeEarly:3000)')';
    t5=nansum(Rasters(prob0,3000-RangeEarly:3000)')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
       
    savestruct(xzv).Pvallast250=Pval;
    savestruct(xzv).Rvallast250=Rval;
    savestruct(xzv).Punclast250=Punc;
    savestruct(xzv).Runclast250=Runc;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %same in amoutn block
    %first 250ms
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(a100,1500:1500+RangeEarly)')';
    t2=nansum(Rasters(a75,1500:1500+RangeEarly)')';
    t3=nansum(Rasters(a50,1500:1500+RangeEarly)')';
    t4=nansum(Rasters(a25,1500:1500+RangeEarly)')';
    t5=nansum(Rasters(a0,1500:1500+RangeEarly)')';
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(a100,1500:1500+RangeEarly)')';
    t2=nansum(Rasters(a75,1500:1500+RangeEarly)')';
    t3=nansum(Rasters(a50,1500:1500+RangeEarly)')';
    t4=nansum(Rasters(a25,1500:1500+RangeEarly)')';
    t5=nansum(Rasters(a0,1500:1500+RangeEarly)')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    savestruct(xzv).Amt_Pvalfirst250=Pval;
    savestruct(xzv).Amt_Rvalfirst250=Rval;
    savestruct(xzv).Amt_Puncfirst250=Punc;
    savestruct(xzv).Amt_Runcfirst250=Runc;
    
    
    %last 250ms
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(a100,3000-RangeEarly:3000)')';
    t2=nansum(Rasters(a75,3000-RangeEarly:3000)')';
    t3=nansum(Rasters(a50,3000-RangeEarly:3000)')';
    t4=nansum(Rasters(a25,3000-RangeEarly:3000)')';
    t5=nansum(Rasters(a0,3000-RangeEarly:3000)')';
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    clear t1 t2 t3 t4 t5
    t1=nansum(Rasters(a100,3000-RangeEarly:3000)')';
    t2=nansum(Rasters(a75,3000-RangeEarly:3000)')';
    t3=nansum(Rasters(a50,3000-RangeEarly:3000)')';
    t4=nansum(Rasters(a25,3000-RangeEarly:3000)')';
    t5=nansum(Rasters(a0,3000-RangeEarly:3000)')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
       
    savestruct(xzv).Amt_Pvallast250=Pval;
    savestruct(xzv).Amt_Rvallast250=Rval;
    savestruct(xzv).Amt_Punclast250=Punc;
    savestruct(xzv).Amt_Runclast250=Runc;
    
    
    
 
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ch1=Rasters(prob100,1500:1500+1500);
ch2=Rasters(prob75,1500:1500+1500);
ch3=Rasters(prob50,1500:1500+1500);
ch4=Rasters(prob25,1500:1500+1500);
ch5=Rasters(prob0,1500:1500+1500);

Corval=[];
CorvalP=[];
Corunc=[];
CoruncP=[];
SingleVector=[];
SingleVectorID=[];
for x = 1:size(ch1,2)-BinForStat
    %x
    
    t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    
    Corval=[Corval; Rval];
    CorvalP=[CorvalP; Pval];    
    
    clear temp t1 t2 t3 t4 t5 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    Corunc=[Corunc; Runc];
    CoruncP=[CoruncP; Punc];
    
    
    if Punc>=CorTh
        Runc=0;
    end
    if Pval>=CorTh
        Rval=0;
    end
    D=0;
    
    
    if abs(Rval)>=abs(Runc)
        V=abs(Rval);
        D=1;
    elseif abs(Rval)<abs(Runc)
        V=abs(Runc)*-1;
        D=2;
    elseif isnan(Rval)==1
        V=0;
        D=1;
    else
        crash %crash here
    end
        
    SingleVector=[SingleVector; V];
    SingleVectorID=[SingleVectorID; D];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
    
end
savestruct(xzv).SingleVectorID=SingleVectorID';
savestruct(xzv).SingleVector=SingleVector';
savestruct(xzv).Corunc=Corunc';
savestruct(xzv).Corval=Corval';
savestruct(xzv).CoruncP=CoruncP';
savestruct(xzv).CorvalP=CorvalP';
savestruct(xzv).CorTh=CorTh;
savestruct(xzv).BinSize=BinForStat;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ch1=Rasters(a100,1500:1500+1500);
ch2=Rasters(a75,1500:1500+1500);
ch3=Rasters(a50,1500:1500+1500);
ch4=Rasters(a25,1500:1500+1500);
ch5=Rasters(a0,1500:1500+1500);

Corval=[];
CorvalP=[];
Corunc=[];
CoruncP=[];
SingleVector=[];
SingleVectorID=[];
for x = 1:size(ch1,2)-BinForStat
    %x
    
    t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
    t1(1:length(t1),2)=5;
    t2(1:length(t2),2)=4;
    t3(1:length(t3),2)=3;
    t4(1:length(t4),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t2; t3; t4; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    
    Corval=[Corval; Rval];
    CorvalP=[CorvalP; Pval];    
    
    clear temp t1 t2 t3 t4 t5 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')';
    t1(1:length(t1),2)=0; %values based on STD of normalized reward (prob dist)
    t2(1:length(t2),2)=0.5;
    t3(1:length(t3),2)=0.57;
    t4(1:length(t4),2)=0.5;
    t5(1:length(t5),2)=0;
    temp=[t1; t2; t3; t4; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    Corunc=[Corunc; Runc];
    CoruncP=[CoruncP; Punc];
    
    
    if Punc>=CorTh
        Runc=0;
    end
    if Pval>=CorTh
        Rval=0;
    end
    D=0;
    
    
    if abs(Rval)>=abs(Runc)
        V=abs(Rval);
        D=1;
    elseif abs(Rval)<abs(Runc)
        V=abs(Runc)*-1;
        D=2;
    elseif isnan(Rval)==1
        V=0;
        D=1;
    else
        crash %crash here
    end
        
    SingleVector=[SingleVector; V];
    SingleVectorID=[SingleVectorID; D];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
    
end
savestruct(xzv).SingleVectorID_a=SingleVectorID';
savestruct(xzv).SingleVector_a=SingleVector';
savestruct(xzv).Corunc_a=Corunc';
savestruct(xzv).Corval_a=Corval';
savestruct(xzv).CoruncP_a=CoruncP';
savestruct(xzv).CorvalP_a=CorvalP';
savestruct(xzv).CorTh_a=CorTh;
savestruct(xzv).BinSize_a=BinForStat;




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ch1=Rasters(prob75d,3020:4000);
ch2=Rasters(prob75nd,3020:4000);
ch3=Rasters(prob50d,3020:4000);
ch4=Rasters(prob50nd,3020:4000);
ch5=Rasters(prob25d,3020:4000);
ch6=Rasters(prob25nd,3020:4000);

Corval=[];
CorvalP=[];
Corunc=[];
CoruncP=[];
SingleVector=[];
SingleVectorID=[];
for x = 1:size(ch1,2)-BinForStat
    %x
    
    t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t6=ch6(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')'; t6=nansum(t6')'; 
    t1=t1-nanmean(t2);
    t3=t3-nanmean(t4);
    t5=t5-nanmean(t6);
    t1(1:length(t1),2)=1;
    t3(1:length(t3),2)=2;
    t5(1:length(t5),2)=3;
    temp=[t1; t3; t5];
    [Pval,Rval]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    
    
    Corval=[Corval; Rval];
    CorvalP=[CorvalP; Pval];    
    
    clear temp t1 t2 t3 t4 t5 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        t1=ch1(:,x:x+BinForStat);
    t2=ch2(:,x:x+BinForStat);
    t3=ch3(:,x:x+BinForStat);
    t4=ch1(:,x:x+BinForStat);
    t5=ch5(:,x:x+BinForStat);
    t6=ch6(:,x:x+BinForStat);
    t1=nansum(t1')'; t2=nansum(t2')'; t3=nansum(t3')'; t4=nansum(t4')'; t5=nansum(t5')'; t6=nansum(t6')'; 
    t1=t1-nanmean(t2);
    t3=t3-nanmean(t4);
    t5=t5-nanmean(t6);
    t1(1:length(t1),2)=1;
    t3(1:length(t3),2)=2;
    t5(1:length(t5),2)=1;
    temp=[t1; t3; t5];
    [Punc,Runc]=permutation_pair_test_fast(temp(:,1),temp(:,2),NumberofPermutations,'corr');
    Corunc=[Corunc; Runc];
    CoruncP=[CoruncP; Punc];
    
    
    if Punc>=CorTh
        Runc=0;
    end
    if Pval>=CorTh
        Rval=0;
    end
    D=0;
    if abs(Rval)>=abs(Runc)
        V=abs(Rval);
        D=1;
    elseif abs(Rval)<abs(Runc)
        V=abs(Runc)*-1;
        D=2;
    elseif isnan(Rval)==1
        V=0;
        D=1;
    else
        crash %crash here
    end
        
    SingleVector=[SingleVector; V];
    SingleVectorID=[SingleVectorID; D];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    clear temp t1 t2 t3 t4 t5 Runc Punc Pval Rval V D
    
end
savestruct(xzv).SingleVectorIDRPE=SingleVectorID';
savestruct(xzv).SingleVectorRPE=SingleVector';
savestruct(xzv).CoruncRPE=Corunc';
savestruct(xzv).CorvalRPE=Corval';
savestruct(xzv).CoruncPRPE=CoruncP';
savestruct(xzv).CorvalPRPE=CorvalP';



