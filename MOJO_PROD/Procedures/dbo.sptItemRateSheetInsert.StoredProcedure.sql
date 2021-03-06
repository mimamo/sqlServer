USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptItemRateSheetInsert]    Script Date: 12/10/2015 12:30:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptItemRateSheetInsert]
	@CompanyKey int,
	@RateSheetName varchar(50),
	@Active tinyint,
	@oIdentity INT OUTPUT
AS --Encrypt

	INSERT tItemRateSheet
		(
		CompanyKey,
		RateSheetName,
		Active
		)

	VALUES
		(
		@CompanyKey,
		@RateSheetName,
		@Active
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
