USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ErrorReturn]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ErrorReturn]
	@ComputerName	VarChar(21)
As
	Select	BatNbr, ComputerName, MsgNbr, Parm00, Parm01, Parm02, Parm03, Parm04, Parm05, S4Future01, SQLErrorNbr
		From	IN10400_Return (NoLock)
		Where	ComputerName = @ComputerName
GO
