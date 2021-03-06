USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsRightGetAssignedList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsRightGetAssignedList]

	(
		@CompanyKey int
	)

AS --Encrypt


Select
	tPreferenceDARights.*,
	Case Entity
		When 'SecurityGroup' then 
			(Select GroupName from tSecurityGroup (NOLOCK) Where SecurityGroupKey = tPreferenceDARightsRight.EntityKey)
		When 'User' then
			(Select FirstName + ' ' + LastName from tUser (NOLOCK) Where UserKey = tPreferenceDARightsRight.EntityKey)
		end as EntityName
	
From
	tPreferenceDARightsRight (NOLOCK) 
	inner join tPreferenceDARights (NOLOCK) on tPreferenceDARights.CompanyKey = tPreferenceDARightsRight.CompanyKey
Where
	tPreferenceDARightsRight.CompanyKey = @CompanyKey
GO
