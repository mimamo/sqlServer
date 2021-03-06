USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWebDavLogInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWebDavLogInsert]
	@CompanyKey int,
	@UserKey int,
	@Method varchar(50),
	@URL varchar(2000),
	@WebDavLogKey uniqueidentifier output
AS

/*
|| When      Who Rel      What
|| 8/31/11   CRG 10.5.4.7 Created
*/

	SELECT	@WebDavLogKey = newid()

	INSERT	tWebDavLog
			(WebDavLogKey,
			CompanyKey,
			UserKey,
			ActionDate,
			Method,
			URL)
	VALUES	(@WebDavLogKey,
			@CompanyKey,
			@UserKey,
			GETUTCDATE(),
			@Method,
			@URL)
GO
