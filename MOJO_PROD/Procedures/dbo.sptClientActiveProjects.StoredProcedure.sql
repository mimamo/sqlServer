USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptClientActiveProjects]    Script Date: 12/10/2015 12:30:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[sptClientActiveProjects]
(
@CompanyKey int,
@ClientKey int,
@UserKey int


)

AS --Encrypt

select 
p.*,
c.CompanyName,
pt.ProjectTypeName,
ps.ProjectStatus as ProjectStatus
from tProject p (nolock) left outer join tCompany c (nolock) on c.CompanyKey = p.ClientKey
left outer join tProjectType pt (noLock) on pt.ProjectTypeKey = p.ProjectTypeKey
left Outer join tProjectStatus ps (nolock) on ps.ProjectStatusKey = p.ProjectStatusKey
where 
p.Active  = 1 
and 
p.ClientKey = @ClientKey 
and 
p.CompanyKey = @CompanyKey
and 
p.ProjectKey in (select ProjectKey from tAssignment (nolock) where UserKey = @UserKey)

return
GO
