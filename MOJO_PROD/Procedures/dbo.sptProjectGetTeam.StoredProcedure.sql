USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectGetTeam]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptProjectGetTeam]
(
	@ProjectKey int
)

as

-- only gets people with services assigned so that it shows people who are working on the project, not everyone with access.

Select UserName, Description as ServiceName 
From tProjectUserServices pu
inner join vUserName u (nolock) on pu.UserKey = u.UserKey
inner join tService s (nolock) on pu.ServiceKey = s.ServiceKey
Where pu.ProjectKey = @ProjectKey
Order By UserName, Description


Select UserName, Phone1, Email
From vUserName u (nolock)
inner join tAssignment pu (nolock) on u.UserKey = pu.UserKey
inner join tProject p (nolock) on pu.ProjectKey = p.ProjectKey
Where pu.ProjectKey = @ProjectKey and ClientVendorLogin = 1 and pu.UserKey <> p.BillingContact
Order By UserName
GO
