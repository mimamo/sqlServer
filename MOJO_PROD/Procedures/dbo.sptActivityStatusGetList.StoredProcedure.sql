USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptActivityStatusGetList]    Script Date: 12/10/2015 12:30:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sptActivityStatusGetList]
(
	@CompanyKey int,
	@ActivityTypeKey int = NULL
)

as


Select a.*, u.UserName, act.TypeName
from tActivityStatus a (nolock)
left outer join vUserName u (nolock) on a.AssignToKey = u.UserKey
left outer join tActivityType act (nolock) on a.ActivityTypeKey = act.ActivityTypeKey
Where a.CompanyKey = @CompanyKey 
and (@ActivityTypeKey is null OR a.ActivityTypeKey = @ActivityTypeKey)
GO
