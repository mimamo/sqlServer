USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositDelete]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositDelete]
	@DepositKey int

AS --Encrypt

	If exists(Select 1 from tCheck (nolock) Where DepositKey = @DepositKey and Posted = 1)
		return -1
		
	Update tCheck Set DepositKey = NULL Where DepositKey = @DepositKey
	
	DELETE
	FROM tDeposit
	WHERE
		DepositKey = @DepositKey 

	RETURN 1
GO
