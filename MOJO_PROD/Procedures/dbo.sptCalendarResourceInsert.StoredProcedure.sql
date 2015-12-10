USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptCalendarResourceInsert]    Script Date: 12/10/2015 12:30:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  PROCEDURE [dbo].[sptCalendarResourceInsert]
	@ResourceName varchar(200),
	@CompanyKey int,
	@oIdentity INT  OUTPUT 
AS --Encrypt

	INSERT tCalendarResource
		(
		ResourceName,
		CompanyKey
		)

	VALUES
		(
		@ResourceName,
		@CompanyKey
		)
	
 
 SELECT @oIdentity = @@IDENTITY
 RETURN 1
GO
