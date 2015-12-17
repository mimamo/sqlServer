USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Customer_CuryID]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10400_Customer_CuryID]
	@CustID		VarChar(15)
As
	Declare	@CuryID	Char(4)
	Set	@CuryID = Space(4)

	Select	@CuryID = CuryID
		From	Customer (NoLock)
		Where	CustID = @CustID

	Select	CuryID = @CuryID
GO
