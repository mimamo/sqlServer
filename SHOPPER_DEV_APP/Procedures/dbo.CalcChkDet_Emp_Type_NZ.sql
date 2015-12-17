USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_Type_NZ]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChkDet_Emp_Type_NZ]
@EmpId  varchar(10),
@EDType varchar(1)
AS
SELECT *
FROM CalcChkDet
WHERE EmpId=@EmpId
      AND EDType=@EDType
      AND (CurrEarnDedAmt<>0 OR CurrUnits<>0)
ORDER BY EmpId, ChkSeq, EDType, WrkLocId, EarnDedID
GO
