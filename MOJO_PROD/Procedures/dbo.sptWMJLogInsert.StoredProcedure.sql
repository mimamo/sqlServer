USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptWMJLogInsert]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptWMJLogInsert]
	@CompanyKey int = NULL,
	@UserKey int = NULL,
	@ErrorSeverity tinyint = NULL,
	@Message varchar(500) = NULL, 
	@Method varchar(100) = NULL,
	@CallingApplicationID varchar(100) = NULL,
	@CallStack varchar(8000) = NULL
AS

/*
|| When      Who Rel      What
|| 2/19/14   KMC 10.5.7.7 Created for the new tEmailSendLog table to track when emails are sent out.
*/

DECLARE @WMJLogKey INT
 
	INSERT INTO tWMJLog
			(ActionDate
			,CompanyKey
			,UserKey
			,Method
			,CallingApplicationID
			,ErrorSeverity
			,Message
			,CallStack)
	VALUES	(GETDATE()
			,@CompanyKey
			,@UserKey
			,@Method
			,@CallingApplicationID
			,@ErrorSeverity
			,@Message
			,@CallStack)

	
	SELECT @WMJLogKey = @@IDENTITY

	RETURN @WMJLogKey
GO
