USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spConvertDB10519]    Script Date: 12/10/2015 10:54:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[spConvertDB10519]

AS
	
	SET NOCOUNT ON

-- because CompanyKey was not set in sptProjectCopyTasks, redo this

update tEstimate
set    tEstimate.CompanyKey = p.CompanyKey
from   tProject p (nolock)
where  tEstimate.ProjectKey = p.ProjectKey
GO
