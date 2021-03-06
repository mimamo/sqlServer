USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_Type_NZ_2]    Script Date: 12/21/2015 14:05:58 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChkDet_Emp_Type_NZ_2]
@EmpId  varchar(10),
@EDType varchar(1)
AS
SELECT *
FROM CalcChkDet
WHERE EmpId=@EmpId
      AND EDType=@EDType
      AND (CurrEarnDedAmt<>0 OR CurrUnits<>0)
ORDER BY EmpId, EDType, WrkLocId, EarnDedID, ChkSeq
GO
