USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectCreativeBriefGet]    Script Date: 12/10/2015 12:30:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectCreativeBriefGet]
	@ProjectKey int

AS --Encrypt

		SELECT pcb.*,
			p.ProjectNumber,
			p.ProjectName,
			p.StartDate,
			p.CompleteDate,
			c.CompanyName as ClientName
		FROM tProjectCreativeBrief pcb (nolock)
		Inner Join tProject p (nolock)on pcb.ProjectKey = p.ProjectKey
		Left Outer Join tCompany c (nolock) on p.ClientKey = c.CompanyKey
		WHERE
			p.ProjectKey = @ProjectKey

	RETURN 1
GO
