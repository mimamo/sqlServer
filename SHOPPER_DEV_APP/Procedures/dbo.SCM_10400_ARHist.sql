USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_ARHist]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_ARHist]
	@CustID		VarChar(15),
	@CpnyID		VarChar(10),
	@FiscYr		Char(4)
As
	Select	*
		From	ARHist (NoLock)
		Where	CustID = @CustID
			And CpnyID = @CpnyID
			And FiscYr = @FiscYr
GO
