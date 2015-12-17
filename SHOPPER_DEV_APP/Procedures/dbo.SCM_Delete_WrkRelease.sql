USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SCM_Delete_WrkRelease]    Script Date: 12/16/2015 15:55:32 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Procedure [dbo].[SCM_Delete_WrkRelease]
	@BatNbr			Varchar(10),
	@UserAddress		Varchar(21)
As
	Set NoCount On

	Delete	From WrkRelease
		Where	BatNbr = @BatNbr
			Or UserAddress = @UserAddress
GO
