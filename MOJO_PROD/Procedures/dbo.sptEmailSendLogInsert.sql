USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptEmailSendLogInsert]    Script Date: 12/10/2015 12:30:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptEmailSendLogInsert]
	@EmailSendLogID varchar(20),
	@CompanyKey int,
	@UserKey int,
	@EmailFromAddress varchar(254),
	@EmailToAddress varchar(254),
	@Subject varchar(100),
	@Body varchar(8000),
	@CallingApplicationID varchar(100) = NULL,
	@Message varchar(500)
AS

/*
|| When      Who Rel      What
|| 2/10/14    KMC 10.5.7.7 Created for the new tEmailSendLog table to track when emails are sent out.
*/

DECLARE @EmailSendLogKey INT
 
	INSERT INTO tEmailSendLog
			(EmailSendLogID
			,ActionDate
			,CompanyKey
			,UserKey
			,EmailFromAddress
			,EmailToAddress
			,Subject
			,Body
			,CallingApplicationID
			,Message)
	VALUES	(@EmailSendLogID
			,GETDATE()
			,@CompanyKey
			,@UserKey
			,@EmailFromAddress
			,@EmailToAddress
			,@Subject
			,@Body
			,@CallingApplicationID
			,@Message)

	
	SELECT @EmailSendLogKey = @@IDENTITY

	RETURN @EmailSendLogKey
GO
