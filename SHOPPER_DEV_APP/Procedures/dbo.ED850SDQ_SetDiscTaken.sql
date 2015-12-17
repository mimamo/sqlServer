USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ED850SDQ_SetDiscTaken]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ED850SDQ_SetDiscTaken] @CpnyId varchar(10), @EDIPOID varchar(10) As
Update ED850SDQ Set DiscTaken = 1 From ED850SDQ A Inner Join ED850LRef B On A.CpnyId = B.CpnyId
And A.EDIPOID = B.EDIPOID And A.LineId = B.LineId And A.StoreNbr = B.RefId Where
A.CpnyId = @CpnyId And A.EDIPOID = @EDIPOID
GO
