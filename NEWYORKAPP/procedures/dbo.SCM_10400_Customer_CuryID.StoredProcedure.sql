USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10400_Customer_CuryID]    Script Date: 12/21/2015 16:01:16 ******/
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
