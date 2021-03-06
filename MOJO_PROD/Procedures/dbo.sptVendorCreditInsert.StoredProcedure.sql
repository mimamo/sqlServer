USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVendorCreditInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptVendorCreditInsert]
	@CompanyKey int,
	@VendorKey int,
	@CreditDate smalldatetime,
	@ClassKey int,
	@APAccountKey int,
	@CreditAmount money,
	@Memo varchar(500),
	@Posted tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt
	
	INSERT tVendorCredit
		(
		CompanyKey,
		VendorKey,
		CreditDate,
		ClassKey,
		APAccountKey,
		CreditAmount,
		Memo,
		Posted
		)

	VALUES
		(
		@CompanyKey,
		@VendorKey,
		@CreditDate,
		@ClassKey,
		@APAccountKey,
		@CreditAmount,
		@Memo,
		@Posted
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
