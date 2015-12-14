USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptDepositInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptDepositInsert]
	@CompanyKey int,
	@DepositID varchar(50),
	@GLAccountKey int,
	@GLCompanyKey int,
	@DepositDate smalldatetime,
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel     What
|| 10/5/07   GWG 8.5     Added GL Company
*/
	If exists(Select 1 from tDeposit (nolock) Where DepositID = @DepositID and GLAccountKey = @GLAccountKey)
		return -1
		
	INSERT tDeposit
		(
		CompanyKey,
		DepositID,
		GLAccountKey,
		GLCompanyKey,
		DepositDate
		)

	VALUES
		(
		@CompanyKey,
		@DepositID,
		@GLAccountKey,
		@GLCompanyKey,
		@DepositDate
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
