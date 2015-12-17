USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_10990_Delete_Retired_INTran]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create	Procedure [dbo].[SCM_10990_Delete_Retired_INTran]
As
	Set	NoCount On
	Declare	@ErrorNo	Integer
	Set	@ErrorNo = 0
	Begin	Transaction

	Delete	From	INTran
		Where	S4Future05 = 1

	Set	@ErrorNo = @@Error
	If	(@ErrorNo = 0)
		Commit Transaction
	Else
		Rollback Transaction
GO
