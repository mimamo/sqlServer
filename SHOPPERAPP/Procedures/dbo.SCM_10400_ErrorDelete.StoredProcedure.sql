USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ErrorDelete]    Script Date: 12/21/2015 16:13:23 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ErrorDelete]
	@BatNbr		VarChar(10),
	@ComputerName	VarChar(21)
As
	Delete	From IN10400_Return
		Where	ComputerName = @ComputerName
			Or BatNbr = @BatNbr
			Or DateAdd(Day, 2, Crtd_DateTime) < GetDate()
GO
