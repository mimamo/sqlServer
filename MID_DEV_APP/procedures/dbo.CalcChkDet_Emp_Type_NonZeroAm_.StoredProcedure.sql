USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_Type_NonZeroAm_]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[CalcChkDet_Emp_Type_NonZeroAm_] @EmpId varchar (10), @EDType varchar (1), @WrkLocId varchar (6),
                                            @EarnDedId varchar (10), @CalYTDEarnDed float as
   Select d.* from CalcChkDet d, CalcChk c
           where d.EmpId     =    @EmpId
             and d.EDType    LIKE @EDType
             and d.WrkLocId  =    @WrkLocId
             and d.EarnDedId =    @EarnDedId
             and
             (   (d.CurrEarnDedAmt     <> 0.0)
              or (d.CurrUnits          <> 0.0)
              or (d.CurrRptEarnSubjDed <> 0.0)
              or (@CalYTDEarnDed       <> 0.0)
             )
             and d.EmpId     =  c.EmpId
             and d.ChkSeq    =  c.ChkSeq
             and c.CheckNbr  <> ''
           order by d.EmpId,
                    d.ChkSeq,
                    d.EDType,
                    d.WrkLocId,
                    d.EarnDedId
GO
