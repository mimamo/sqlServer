USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSystemMessageGetOpen]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSystemMessageGetOpen]

	(
		@UserKey int,
		@PlainOnly tinyint = 0
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/1/07    CRG 8.4.3   (8930) Added check to see if user wants to see all System Messages
|| 5/22/07   CRG 8.4.3   Wrapped sm.AdminOnly with ISNULL
|| 7/1/07	 GWG 8.5	 added inactive date
|| 10/5/07   GWG 8.5   added a return if a client vendor login
|| 11/10/08  GWG 10.0.1.2 Added handling for WJ simpler message
|| 10/15/10  GWG 10.5.3.6 Changed handling for wj only message
|| 06/22/11  GHL 10.5.4.5 (88774) Added tSystemMessage.LabKey so that we display the message 
||                        if the lab has not been enabled for the company 
*/

Declare @Admin tinyint, @SecGroup int, @ClientVendorLogin tinyint, @CompanyKey int

Select @Admin = Administrator
	  ,@SecGroup = SecurityGroupKey 
	  ,@CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
from tUser (nolock) Where UserKey = @UserKey

if @ClientVendorLogin = 1
	return -1
	

if @PlainOnly = 0
BEGIN
	Select MessageText, PlainMessageText, DateAdded
	From
		tSystemMessage sm (nolock)
		
	Where
		sm.Active = 1
		and (
				(ISNULL(sm.AdminOnly, 0) <= @Admin and sm.SecurityRight is null)
				OR 
				(sm.SecurityRight in 
					(Select RightID from tRight r (nolock) 
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						Where ra.EntityType = 'Security Group'
						and ra.EntityKey = @SecGroup )
					or (@Admin = 1 and sm.AdminOnly = 1)
				)
				OR
				((SELECT SystemMessage FROM tUser (nolock) WHERE UserKey = @UserKey) = 1)
			)
		and sm.SystemMessageKey not in (Select SystemMessageKey from tSystemMessageUser (nolock) Where UserKey = @UserKey)
		and (
			isnull(sm.LabKey, 0) = 0 or  
			sm.LabKey not in (select LabKey from tLabCompany (nolock) where CompanyKey = @CompanyKey)
			)
		and (sm.InactiveDate is null or sm.InactiveDate > GETDATE())
		and sm.MessageText is not null


END
ELSE
BEGIN

	Select MessageText, PlainMessageText, DateAdded
	From
		tSystemMessage sm (nolock)
		
	Where
		sm.Active = 1
		and (
				(ISNULL(sm.AdminOnly, 0) <= @Admin and sm.SecurityRight is null)
				OR 
				(sm.SecurityRight in 
					(Select RightID from tRight r (nolock) 
						inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
						Where ra.EntityType = 'Security Group'
						and ra.EntityKey = @SecGroup )
					or (@Admin = 1 and sm.AdminOnly = 1)
				)
				OR
				((SELECT SystemMessage FROM tUser (nolock) WHERE UserKey = @UserKey) = 1)
			)
		and sm.SystemMessageKey not in (Select SystemMessageKey from tSystemMessageUser (nolock) Where UserKey = @UserKey)
		and (
			isnull(sm.LabKey, 0) = 0 or  
			sm.LabKey not in (select LabKey from tLabCompany (nolock) where CompanyKey = @CompanyKey)
			)
		and (sm.InactiveDate is null or sm.InactiveDate > GETDATE())
		and sm.PlainMessageText is not null

END
GO
