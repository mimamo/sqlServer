USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Delete_Retired_LotSerT]    Script Date: 12/21/2015 16:07:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Delete_Retired_LotSerT]
As
	Set	NoCount On
	Declare	@ErrorNo	Integer
	Set	@ErrorNo = 0
	Begin	Transaction

	Delete	From	LotSerT
		Where	S4Future05 = 1

	Set	@ErrorNo = @@Error
	If	(@ErrorNo = 0)
		Commit Transaction
	Else
		Rollback Transaction
GO
