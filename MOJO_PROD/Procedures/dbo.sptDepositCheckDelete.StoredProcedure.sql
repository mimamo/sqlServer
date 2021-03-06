USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositCheckDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositCheckDelete]

	(
		@DepositKey int,
		@CheckKey int
	)

AS

If exists(Select 1 from tCheck (nolock) Where CheckKey = @CheckKey and Posted = 1)
	return -1
	
If exists(Select 1 from tDeposit (nolock) Where DepositKey = @DepositKey and Cleared = 1)
	return -2
	
Update tCheck
Set DepositKey = NULL
Where
	CheckKey = @CheckKey
GO
