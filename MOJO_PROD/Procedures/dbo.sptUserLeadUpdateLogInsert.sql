USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptUserLeadUpdateLogInsert]    Script Date: 12/10/2015 12:30:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptUserLeadUpdateLogInsert]
	@UserLeadKey int,
	@UserKey int, -- -1 indicates the WSS
	@Action char(1), --I:Insert, U:Update, D:Delete, E: Email Update (Used for Emma)
	@StoredProc varchar(50),
	@ParameterList varchar(1500),
	@Application varchar(50) = NULL
AS

/*
|| When      Who Rel      What
|| 03/01/10  QMD 10.5.1.9 Initial Release:  Proc used to insert into the UserLeadUpdateLog table 
|| 04/07/11  QMD 10.5.4.3 Updated comment with E value for action
|| 11/14/12  QMD 10.5.6.2 Added ExternalMarketingKey
*/
  -- Log Deletes
    INSERT INTO tUserLeadUpdateLog
    SELECT	ModifiedByKey = @UserKey, 
			ModifiedDate = GETUTCDATE(),
			[Action] = @Action,
			StoredProc = @StoredProc,
			ParameterList = @ParameterList,
			[Application] = @Application,
			UserLeadKey, 
			CompanyKey, 
			FirstName, 
			MiddleName, 
			LastName, 
			Salutation, 
			Phone1, 
			Phone2, 
			Cell, 
			Fax, 
			Pager, 
			Title,
			Email, 
			CompanyName, 
			CompanyPhone, 
			CompanyFax, 
			CompanyWebsite, 
			CompanySourceKey, 
			CompanyTypeKey, 
			OppSubject,
			OppAmount, 
			OppProjectTypeKey, 
			OppDescription, 
			ContactMethod, 
			DoNotCall, 
			DoNotEmail, 
			DoNotMail, 
			DoNotFax, 
			Active,
			UserCustomFieldKey, 
			CompanyCustomFieldKey, 
			OppCustomFieldKey, 
			AddedByKey, 
			UpdatedByKey, 
			DateAdded, 
			DateUpdated, 
			TimeZoneIndex, 
			OwnerKey, 
			CMFolderKey, 
			AddressKey, 
			HomeAddressKey, 
			OtherAddressKey, 
			Department, 
			UserRole, 
			Assistant,
			AssistantPhone, 
			AssistantEmail, 
			Birthday, 
			SpouseName, 
			Children, 
			Anniversary, 
			Hobbies, 
			LastActivityKey, 
			NextActivityKey, 
			Comments, 
			InactiveDate,
			ExternalMarketingKey
    FROM	tUserLead 
    WHERE	UserLeadKey = @UserLeadKey
GO
