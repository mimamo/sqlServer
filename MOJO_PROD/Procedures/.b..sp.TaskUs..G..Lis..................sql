USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptTaskUserGetList]    Script Date: 12/10/2015 10:54:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptTaskUserGetList]
	(
		@ProjectKey int
	)
AS --Encrypt


Select tu.* 
from tTaskUser tu (nolock)
	inner join tTask t (nolock) on tu.TaskKey = t.TaskKey
 Where t.ProjectKey = @ProjectKey
GO
