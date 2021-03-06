USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptPreferenceDARightsGetAssignedList]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptPreferenceDARightsGetAssignedList]

	(
		@CompanyKey int
	)

AS --Encrypt


Select
	tPreferenceDARights.*,
	Case Entity
		When 'SecurityGroup' then 
			(Select GroupName from tSecurityGroup (NOLOCK) Where SecurityGroupKey = tPreferenceDARights.EntityKey)
		When 'User' then
			(Select FirstName + ' ' + LastName from tUser (NOLOCK) Where UserKey = tPreferenceDARights.EntityKey)
		end as EntityName
	
From
	tPreferenceDARights (NOLOCK) 
Where
	CompanyKey = @CompanyKey
GO
