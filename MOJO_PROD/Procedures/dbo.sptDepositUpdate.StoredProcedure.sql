USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositUpdate]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositUpdate]
	@DepositKey int,
	@DepositID varchar(50),
	@DepositDate smalldatetime

AS --Encrypt

Declare @GLAccountKey int

	Select @GLAccountKey = GLAccountKey from tDeposit (nolock) Where DepositKey = @DepositKey

	If exists(Select 1 from tDeposit (nolock) Where DepositID = @DepositID and GLAccountKey = @GLAccountKey and DepositKey <> @DepositKey)
		return -1
		
	UPDATE
		tDeposit
	SET
		DepositID = @DepositID,
		DepositDate = @DepositDate
	WHERE
		DepositKey = @DepositKey 

	RETURN 1
GO
