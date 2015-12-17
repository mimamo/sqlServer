USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_Emp_Seq_EDTp_Id_]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChkDet_Emp_Seq_EDTp_Id_]
@EmpID   varchar(10),
@ChkSeq  varchar(2),
@EDType  varchar(1),
@WrkLocId varchar(6),
@EDid    varchar(10)
AS
SELECT *
FROM CalcChkDet
WHERE EmpID=@EmpID AND ChkSeq=@ChkSeq AND EDType=@EDType AND WrkLocId=@WrkLocId AND EarnDedID=@EDid
GO
