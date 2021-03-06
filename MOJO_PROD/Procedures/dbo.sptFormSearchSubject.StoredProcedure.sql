USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptFormSearchSubject]    Script Date: 12/10/2015 12:30:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptFormSearchSubject]

	(
		@FormDefKey int,
		@SearchValue varchar(500)
	)

AS

/*
|| When      Who Rel     What
|| 3/26/08   CRG 1.0.0.0 Added ASC_Selected
*/

if @SearchValue is null
Select
	f.FormKey,
	Cast(f.FormNumber as varchar) + '-' + fd.FormPrefix as FormID,
	p.ProjectNumber,
	p.ProjectName,
	f.Subject,
	0 AS ASC_Selected
From
	tForm f (nolock)
	inner join tFormDef fd (nolock) on f.FormDefKey = fd.FormDefKey
	left outer join tProject p (nolock) on f.ProjectKey = p.ProjectKey
Where
	f.FormDefKey = @FormDefKey

Else
Select
	f.FormKey,
	Cast(f.FormNumber as varchar) + '-' + fd.FormPrefix as FormID,
	p.ProjectNumber,
	p.ProjectName,
	f.Subject,
	0 AS ASC_Selected
From
	tForm f (nolock)
	inner join tFormDef fd (nolock) on f.FormDefKey = fd.FormDefKey
	left outer join tProject p (nolock) on f.ProjectKey = p.ProjectKey
Where
	f.FormDefKey = @FormDefKey and
	f.Subject like '%' + @SearchValue + '%'
GO
