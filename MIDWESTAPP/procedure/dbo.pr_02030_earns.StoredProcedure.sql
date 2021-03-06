USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[pr_02030_earns]    Script Date: 12/21/2015 15:55:40 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[pr_02030_earns]
@EmpID     varchar (10),
@EarnDedID varchar (10),
@ChkSeq    varchar (2)
AS
SELECT CalcChkDet.*, EarnType.*
FROM CalcChkDet
     LEFT OUTER JOIN EarnType
         ON CalcChkDet.EarnDedId=EarnType.Id
WHERE CalcChkDet.EmpId = @EmpID
      AND CalcChkDet.EDType = 'E'
      AND CalcChkDet.EarnDedId LIKE @EarnDedID
      AND CalcChkDet.ChkSeq LIKE @ChkSeq
ORDER BY EmpId, ChkSeq, EDType, WrkLocId, EarnDedId
GO
