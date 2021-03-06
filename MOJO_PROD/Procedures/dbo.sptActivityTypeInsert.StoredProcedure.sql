USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityTypeInsert]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptActivityTypeInsert]
	@CompanyKey int,
	@TypeName varchar(200),
	@Active int,
	@AutoRollDate tinyint,
	@TypeColor varchar(50),
	@oIdentity INT OUTPUT
AS --Encrypt

/*
|| When      Who Rel      What
|| 01/14/09  RTC 10.5.0.0 Initial Release
|| 05/07/09  CRG 10.5.0.0 Added TypeColor
*/

	INSERT tActivityType
		(
		CompanyKey,
		TypeName,
		Active,
		AutoRollDate,
		LastModified,
		TypeColor
		)

	VALUES
		(
		@CompanyKey,
		@TypeName,
		@Active,
		@AutoRollDate,
		GetDate(),
		@TypeColor
		)
	
	SELECT @oIdentity = @@IDENTITY

	RETURN 1
GO
