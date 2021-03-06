USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceUpdatePop3]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceUpdatePop3]
	(
	@CompanyKey INT
	,@PopServer VARCHAR(250)
	,@PopUserID VARCHAR(250)
	,@PopPassword VARCHAR(250)
	,@SystemEmail varchar(300)
	,@ForceSystemAsFrom tinyint
	,@PopUseSSL tinyint = 0 --optional for compatibility with CMP85
	,@PopPort int = NULL --optional for compatibility with CMP85
	)

AS -- Encrypt

/*
|| When     Who Rel      What
|| 11/8/06  CRG 8.35     Added SystemEmail and ForceSystemAsFrom.
|| 12/9/08  CRG 10.0.1.4 Added PopUseSSL and PopPort
*/

	SET NOCOUNT ON
	
	UPDATE tPreference
	SET PopServer = @PopServer
		,PopUserID = @PopUserID
		,PopPassword = @PopPassword
		,SystemEmail = @SystemEmail
		,ForceSystemAsFrom = @ForceSystemAsFrom
		,PopUseSSL = @PopUseSSL
		,PopPort = @PopPort
	WHERE CompanyKey = @CompanyKey
	
	 
	RETURN 1
GO
