USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Close_PR_Copy_Tables]    Script Date: 12/21/2015 15:36:50 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Close_PR_Copy_Tables] @oldyr varchar ( 4), @newyr varchar ( 4), @Crtd_Prog varchar(8), @Crtd_User varchar(10) as

set nocount ON

insert Deduction
    select AllId,AllocDed,ArrgDedAllow,BaseId,BaseType,BoxLet,BoxNbr,BwkIntrv,
           BwkMaxAmtPerPd,BwkMaxPerYr,BwkMinAmtPerPd,BwkPaySeq,
           BwkSchedule,BwkStrtPer,CalcMthd,
           @newyr,ChkSeq,ChkSeqAll,CpnyID,CpnyTaxNbr,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,DedGrpID,DedId,DedSequence,DedType,DefrdComp,Descr,
           EmpleeDed,ExpAcct,ExpSub,ExpSubSrc,FxdPctRate,HeadId,IncInDispEarn,
           JointId,Lifetime,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,MarriedId,MaxApplyFlg,MaxDedAmt,MaxSubjWage,MinSubjWage,
           MonIntrv,MonMaxAmtPerPd,MonMaxPerYr,MonMinAmtPerPd,MonStrtPer,
           NoteId,OmitRptEarn,Pension,PrntEmplr, PrntZeroDed, ProjBillable,ProjImpact,RoundToDollars,S4Future01,
           S4Future02,S4Future03,S4Future04,S4Future05,S4Future06,
           S4Future07,S4Future08,S4Future09,S4Future10,S4Future11,
           S4Future12,Section457,SingleId,SmonIntrv,SmonMaxAmtPerPd,
           SmonMaxPerYr,SmonMinAmtPerPd,SmonPaySeq,SmonSchedule,SmonStrtPer,
           State,SubjAllEarnings,SubjAllLaborCls,SubjAllWrkloc,Union_cd,UpdProject,User1,User2,User3,User4,
           User5,User6,User7,User8,VendId,WklyIntrv,WklyMaxAmtPerPd,WklyMaxPerYr,
           WklyMinAmtPerPd,WklyStrtPer,WkPaySeq,WkSchedule,WthldAcct,
           WthldSub,WthldSubSrc,null
      from Deduction Ded2
     where Ded2.CalYr = @oldyr
       and NOT exists (select DedId
                         from Deduction Ded3
                        where Ded3.DedId = Ded2.DedId
                          and Ded3.CalYr = @newyr)

insert ExmptCredit
    select AnnMaxAmt,AnnMinAmt,Annualize,BaseDedId,BaseType,CalcMthd,
           @newyr,CpnyID,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,DedId,Descr,ExmptCr,ExmptCrId,ExmptID,FxdPctRate,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,MarStat,MaxApplyFlg,NoteId,PayTblId,RedRptEarnSubjDed,
           S4Future01,S4Future02,S4Future03,S4Future04,S4Future05,S4Future06,
           S4Future07,S4Future08,S4Future09,S4Future10,S4Future11,S4Future12,
           User1,User2,User3,User4,User5,User6,User7,User8,null
      from ExmptCredit ExmpCr2
     where ExmpCr2.CalYr = @oldyr
       and NOT exists (select ExmptCrId
                         from ExmptCredit ExmpCr3
                        where ExmpCr3.DedId     = ExmpCr2.DedId
                          and ExmpCr3.CalYr     = @newyr
                          and ExmpCr3.MarStat   = ExmpCr2.MarStat
                          and ExmpCr3.ExmptCr   = ExmpCr2.ExmptCr
                          and ExmpCr3.ExmptCrId = ExmpCr2.ExmptCrId)

insert DeductCpny
    select @newyr,CpnyID,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,DedId,ExpAcct,ExpSub,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,ProjBillable,ProjImpact,S4Future01,S4Future02,S4Future03,S4Future04,S4Future05,
           S4Future06,S4Future07,S4Future08,S4Future09,S4Future10,S4Future11,
           S4Future12,UpdProject,User1,User2,User3,User4,User5,User6,User7,User8,WthldAcct,WthldSub,null
      from DeductCpny DedCpny2
     where DedCpny2.CalYr = @oldyr
       and NOT exists (select DedId
                         from DeductCpny DedCpny3
                        where DedCpny3.DedId     = DedCpny2.DedId
                          and DedCpny3.CalYr     = @newyr
                          and DedCpny3.CpnyId    = DedCpny2.CpnyId)

insert PRTableHeader
    select @newyr,CpnyID,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,Descr,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,NoteId,PayTblId,S4Future01,S4Future02,S4Future03,
           S4Future04,S4Future05,S4Future06,S4Future07,S4Future08,S4Future09,
           S4Future10,S4Future11,S4Future12,TblType,User1,User2,User3,User4,
           User5,User6,User7,User8,null
      from PRTableHeader PRTab2
     where PRTab2.CalYr = @oldyr
       and NOT exists (select PayTblId
                         from PRTableHeader PRTab3
                        where PRTab3.PayTblId = PRTab2.PayTblId
                          and PRTab3.CalYr    = @newyr)

insert PRTableDetail
    select AmtAdded,
           @newyr,CpnyID,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,LineID,LineNbr,
           getdate(),
           @Crtd_Prog,
           @Crtd_User,MinAmt,NoteId,PayTblId,Pct,S4Future01,S4Future02,
           S4Future03,S4Future04,S4Future05,S4Future06,S4Future07,
           S4Future08,S4Future09,S4Future10,S4Future11,S4Future12,
           User1,User2,User3,User4,User5,User6,User7,User8,null
      from PRTableDetail PRTabdet2
     where PRTabdet2.CalYr = @oldyr
       and NOT exists (select PayTblId
                         from PRTableDetail PRTabdet3
                        where PRTabdet3.PayTblId = PRTabdet2.PayTblId
                          and PRTabdet3.CalYr    = @newyr
                          and PRTabdet3.LineNbr  = PRTabdet2.LineNbr)

set nocount OFF
GO
