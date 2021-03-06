USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spNotifyTaskDetails]    Script Date: 12/10/2015 12:30:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE  Procedure [dbo].[spNotifyTaskDetails]

	(
		@TaskKey int
	)

AS --Encrypt

Select
	t.*,
	p.ProjectKey,
	p.ProjectNumber,
	p.ProjectName,
	p.ClientKey,
	p.AccountManager,
	p.OfficeKey
from
	tTask t (nolock) 
	inner join tProject p (nolock) on t.ProjectKey = p.ProjectKey
Where
	t.TaskKey = @TaskKey
GO
