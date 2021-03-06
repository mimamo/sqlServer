USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsRightGetUnAssignedList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsRightGetUnAssignedList]

	(
		@CompanyKey int
	)

AS --Encrypt


Select
	'SecurityGroup' as Entity,
	SecurityGroupKey as EntityKey,
	GroupName as EntityName
From tSecurityGroup (NOLOCK) 
Where
	CompanyKey = @CompanyKey and
	Active = 1 and
	SecurityGroupKey not in (Select EntityKey from tPreferenceDARights (NOLOCK) Where CompanyKey = @CompanyKey and Entity = 'SecurityGroup')
	
	
UNION ALL

Select
	'User' as Entity,
	tUser.UserKey as EntityKey,
	tUser.FirstName + ' ' + tUser.LastName as EntityName
From
	tUser (NOLOCK) 
Where
	UserKey not in (Select EntityKey from tPreferenceDARights (NOLOCK) Where CompanyKey = @CompanyKey and Entity = 'User') and
	CompanyKey = @CompanyKey and Active = 1
GO
