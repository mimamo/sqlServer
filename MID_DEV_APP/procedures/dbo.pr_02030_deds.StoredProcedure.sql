USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[pr_02030_deds]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pr_02030_deds]
@EmpID  varchar (10),
@CalYr  varchar (4),
@DedID  varchar (10),
@ChkSeq varchar (2)
AS
SELECT CalcChkDet.*, Deduction.*
FROM CalcChkDet
     LEFT OUTER JOIN Deduction
         ON CalcChkDet.EarnDedID=Deduction.DedID
WHERE CalcChkDet.EmpId = @EmpID
      AND CalcChkDet.EDType = 'D'
      AND CalcChkDet.EarnDedId LIKE @DedID
      AND Deduction.CalYr=@CalYr
      AND CalcChkDet.ChkSeq LIKE @ChkSeq
ORDER BY EmpId, CalcChkDet.ChkSeq, EDType, WrkLocId, EarnDedId
GO
