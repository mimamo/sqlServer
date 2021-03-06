USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadDelete]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadDelete]
 @UserLeadKey int,
 @UserKey int

AS --Encrypt

  /*
  || When     Who Rel       What
  || 07/28/08 QMD 10.5.0.0  Initial Release
  || 05/15/09 GHL 10.5.0.0  Added OppCustomFieldKey + deletions of associated tables
  || 02/26/10 QMD 10.5.1.9  Added UserKey and Insert into tUserLeadUpdateLog
  */

	declare @CompanyKey int, @UserCustomFieldKey int, @CompanyCustomFieldKey int, @OppCustomFieldKey int
	
	Select    @CompanyKey = CompanyKey
	        , @UserCustomFieldKey = UserCustomFieldKey
			, @CompanyCustomFieldKey = CompanyCustomFieldKey 
			, @OppCustomFieldKey = OppCustomFieldKey 			
	from tUserLead (nolock) Where UserLeadKey = @UserLeadKey
	
	exec spCF_tObjectFieldSetDelete @UserCustomFieldKey
	exec spCF_tObjectFieldSetDelete @CompanyCustomFieldKey
	exec spCF_tObjectFieldSetDelete @OppCustomFieldKey
	
	DELETE tActivityLink
	WHERE	Entity = 'tUserLead'
	AND EntityKey = @UserLeadKey

	-- Log Marketing List List Deletes
	DECLARE @parmList VARCHAR(50)
	SELECT @parmList = '@UserLeadKey = ' + CONVERT(VARCHAR(10),@UserLeadKey)
    EXEC sptMarketingListListDeleteLogInsert @UserKey, @UserLeadKey, 'tUserLead', 'sptUserLeadDelete', @parmList, 'UI'

	DELETE tMarketingListList
	WHERE	Entity = 'tUserLead'
	AND EntityKey = @UserLeadKey
	
	--Delete Addresses
	DELETE	tAddress
	WHERE	Entity = 'tUserLead'
	AND EntityKey = @UserLeadKey

	UPDATE tContactActivity SET UserLeadKey = NULL 
    WHERE  CompanyKey = @CompanyKey
    AND    UserLeadKey = @UserLeadKey
    
    UPDATE tActivity SET UserLeadKey = NULL 
    WHERE  CompanyKey = @CompanyKey
    AND    UserLeadKey = @UserLeadKey
    
    -- Log Deletes
    EXEC sptUserLeadUpdateLogInsert @UserLeadKey, @UserKey, 'D', 'sptUserLeadDelete', @parmList, 'UI'
    
	--Delete User Lead
	DELETE	tUserLead
	WHERE	UserLeadKey = @UserLeadKey
GO
