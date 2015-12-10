USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptServiceReplace]    Script Date: 12/10/2015 10:54:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptServiceReplace]
	(
	@ServiceKey int
	,@ReplaceByServiceKey int
	)
AS --Encrypt

  /*
  || When     Who Rel    What
  || 03/08/12 GHL 10.554 (132311) Creation to be able to replace a service by another
  ||                     (usually after marking it inactive) on employee services and open tasks
  */

	SET NOCOUNT ON

	declare @CompanyKey int

	select @CompanyKey = CompanyKey from tService (nolock) where ServiceKey = @ServiceKey

	if @@ROWCOUNT = 0
		return 1

	if not exists (select 1 from tService (nolock) where CompanyKey = @CompanyKey and ServiceKey = @ReplaceByServiceKey)
		return 1

	update tUser
	set    DefaultServiceKey = @ReplaceByServiceKey
	where  CompanyKey = @CompanyKey
	and    DefaultServiceKey = @ServiceKey

	update tUserService
	set    tUserService.ServiceKey = @ReplaceByServiceKey
	from   tUser u (nolock)
	where  tUserService.UserKey = u.UserKey
	and    u.CompanyKey = @CompanyKey
	and    tUserService.ServiceKey = @ServiceKey

	update tTaskUser
	set    tTaskUser.ServiceKey = @ReplaceByServiceKey
	from   tTask t (nolock)
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
	where p.CompanyKey = @CompanyKey
	and   tTaskUser.TaskKey = t.TaskKey  
	and   tTaskUser.ServiceKey = @ServiceKey
	and   t.PercComp < 100  

	RETURN 1
GO
