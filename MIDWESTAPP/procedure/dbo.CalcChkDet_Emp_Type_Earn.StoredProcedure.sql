USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_Type_Earn]    Script Date: 12/21/2015 15:55:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc  [dbo].[CalcChkDet_Emp_Type_Earn] @EmpId     varchar (10),
                                      @EDType    varchar (1),
                                      @CheckNbr  varchar (10) as
   Select d.* from CalcChkDet d, CalcChk c
           where c.EmpId     =    @EmpId
             and c.CheckNbr  =    @CheckNbr
             and d.EmpId     =    c.EmpId
             and d.ChkSeq    =    c.ChkSeq
             and d.EDType    LIKE @EDType
           order by d.EmpId,
                    d.ChkSeq,
                    d.EDType,
                    d.WrkLocId,
                    d.EarnDedId
GO
