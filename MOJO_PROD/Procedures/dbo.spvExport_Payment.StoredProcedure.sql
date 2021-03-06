USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[spvExport_Payment]    Script Date: 12/10/2015 12:30:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spvExport_Payment]

	(
		@CompanyKey int,
		@IncludeDownloaded tinyint = 0
	)

AS --Encrypt

select 
	* 
from 
	vExport_Payment (NOLOCK)
where
	CompanyKey = @CompanyKey and
	Downloaded <= @IncludeDownloaded
GO
