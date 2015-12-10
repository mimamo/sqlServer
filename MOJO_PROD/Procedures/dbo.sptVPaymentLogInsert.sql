USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptVPaymentLogInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE proc [dbo].[sptVPaymentLogInsert]
	@UserKey int,
	@Method varchar(50),
	@QS varchar(max),
	@VPaymentLogKey uniqueidentifier OUTPUT,
	@CompanyKey int = 0
AS

/*
|| When      Who Rel      What
|| 11/3/14   CRG 10.5.8.6 Created
*/

	IF @CompanyKey = 0	
		SELECT	@CompanyKey = CompanyKey
		FROM	tUser (nolock)
		WHERE	UserKey = @UserKey
	
	SELECT	@VPaymentLogKey = NEWID()

	INSERT	tVPaymentLog
			(VPaymentLogKey,
			CompanyKey,
			ActionDate,
			UserKey,
			Method,
			QS)
	VALUES	(@VPaymentLogKey,
			@CompanyKey,
			GETUTCDATE(),
			@UserKey,
			@Method,
			@QS)
GO
