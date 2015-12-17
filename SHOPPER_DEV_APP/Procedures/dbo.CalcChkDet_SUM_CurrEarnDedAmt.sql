USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_SUM_CurrEarnDedAmt]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[CalcChkDet_SUM_CurrEarnDedAmt] @EmpId varchar (10), @EDType varchar (1), @WrkLocId varchar (6), @EarnDedId varchar (10)  as
   Select sum(CurrEarnDedAmt) from CalcChkDet d, CalcChk c
           where d.EmpId     =    @EmpId
             and d.EDType    LIKE @EDType
             and d.WrkLocId  =    @WrkLocId
             and d.EarnDedId =    @EarnDedId
             and d.EmpId     =    c.EmpId
             and d.ChkSeq    =    c.ChkSeq
             and c.CheckNbr  <>   ''
GO
