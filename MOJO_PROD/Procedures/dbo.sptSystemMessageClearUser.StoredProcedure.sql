USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptSystemMessageClearUser]    Script Date: 12/10/2015 12:30:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptSystemMessageClearUser]

	(
		@UserKey int,
		@PlainOnly tinyint = 0
	)

AS --Encrypt

/*
|| When      Who Rel     What
|| 5/22/07   CRG 8.4.3   Wrapped sm.AdminOnly with ISNULL
|| 11/10/08  GWG 10.0.1.2 Added handling for WJ simpler message
|| 06/22/11  GHL 10.5.4.5 (88774) Added tSystemMessage.LabKey so that we display the message 
||                        if the lab has not been enabled for the company 
*/

Declare @Admin tinyint, @SecGroup int, @SystemMessage tinyint, @CompanyKey int

Select @Admin = Administrator
      , @SecGroup = SecurityGroupKey
	  , @SystemMessage = SystemMessage 
	  , @CompanyKey = isnull(OwnerCompanyKey, CompanyKey)
from tUser (nolock) Where UserKey = @UserKey

Insert tSystemMessageUser (SystemMessageKey, UserKey, DateViewed)
Select sm.SystemMessageKey, @UserKey, GETUTCDATE()
	From tSystemMessage sm (nolock)
Where
	sm.Active = 1
	and (
			(ISNULL(sm.AdminOnly, 0) <= @Admin and sm.SecurityRight is null)
			OR 
			@SystemMessage = 1
			OR
			(sm.SecurityRight in 
				(Select RightID from tRight r (nolock) 
					inner join tRightAssigned ra (nolock) on r.RightKey = ra.RightKey
					Where ra.EntityType = 'Security Group'
					and ra.EntityKey = @SecGroup )
				or (@Admin = 1 and sm.AdminOnly = 1)
			)
		)
	and sm.SystemMessageKey not in (Select SystemMessageKey from tSystemMessageUser (nolock) Where UserKey = @UserKey)
	and (
		isnull(sm.LabKey, 0) = 0 or  
		sm.LabKey not in (select LabKey from tLabCompany (nolock) where CompanyKey = @CompanyKey)
		)
	and (@PlainOnly = 0 OR sm.PlainMessageText is not null)
GO
