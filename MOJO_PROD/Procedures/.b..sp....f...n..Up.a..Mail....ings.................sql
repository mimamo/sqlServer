USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdateMailSettings]    Script Date: 12/10/2015 10:54:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdateMailSettings]
	(
	@CompanyKey INT
	,@PopServer VARCHAR(250)
	,@PopUserID VARCHAR(250)
	,@PopEmail VARCHAR(250)
	,@PopPassword VARCHAR(250)
	,@SystemEmail varchar(300)
	,@ForceSystemAsFrom tinyint
	,@PopUseSSL tinyint 
	,@PopPort int 
	,@MissingTime DATETIME
	,@MissingTimeSheet DATETIME
	,@MissingTimeSheetFreq SMALLINT
	,@BudgetUpdate DATETIME
	,@DeliverableStatus DATETIME
	,@MissingApproval DATETIME
	,@TaskReminder DATETIME
	,@EmailProtocol TINYINT = 0
	,@EmailFooter text
	,@UnsubmittedTimeSheet DATETIME
	,@UnsubmittedTimeSheetFreq SMALLINT
	)

AS -- Encrypt

/*
|| When     Who Rel      What
|| 12/17/09 RLB 10.516   Created for the new flash Mails settings page.
|| 01/13/11 MFT 10.5.4.0 Added PopEmail
|| 03/21/11 RLB 10.5.4.2 Added Task Reminder
|| 03/21/11 QMD 10.5.5.6 Added Email Protocol
|| 04/22/13 WDF 10.5.6.7 (168393) Added Email Footer
|| 05/13/13 MFT 10.5.6.8 Added @UnsubmittedTimeSheet & @UnsubmittedTimeSheetFreq
*/

	SET NOCOUNT ON
	
	UPDATE tPreference
	SET  PopServer = @PopServer
		,PopUserID = @PopUserID
		,PopEmail = @PopEmail
		,PopPassword = @PopPassword
		,SystemEmail = @SystemEmail
		,ForceSystemAsFrom = @ForceSystemAsFrom
		,PopUseSSL = @PopUseSSL
		,PopPort = @PopPort
		,MissingTime = @MissingTime
		,MissingTimeSheet = @MissingTimeSheet
		,MissingTimeSheetFreq = @MissingTimeSheetFreq
		,BudgetUpdate = @BudgetUpdate
		,MissingApproval = @MissingApproval
		,DeliverableStatus = @DeliverableStatus
		,TaskReminder = @TaskReminder
		,EmailProtocol = @EmailProtocol
		,EmailFooter = @EmailFooter
		,UnsubmittedTimeSheet = @UnsubmittedTimeSheet
		,UnsubmittedTimeSheetFreq = @UnsubmittedTimeSheetFreq
		
	WHERE CompanyKey = @CompanyKey
	 
	RETURN 1
GO
