USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CalcChkDet_del]    Script Date: 12/21/2015 14:17:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[CalcChkDet_del]
@EmpID   varchar(10),
@ChkSeq  varchar(2),
@EDType  varchar(1),
@WrkLocId varchar(6),
@EDid    varchar(10)
AS
DELETE CalcChkDet
WHERE EmpID=@EmpID AND ChkSeq=@ChkSeq AND EDType=@EDType AND WrkLocId=@WrkLocId AND EarnDedID=@EDid
GO
