USE [MOJo_prod]
GO
/****** Object:  StoredProcedure [dbo].[sptProjectTypeServiceGetList]    Script Date: 12/10/2015 10:54:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sptProjectTypeServiceGetList]

	(
		@ProjectTypeKey int
	)

AS --Encrypt
	Select
		s.*
		,ISNULL(s.ServiceCode, '') + ' - ' + ISNULL(s.Description, '') as FullDescription  
	From
		tService s (nolock) 
		Inner join tProjectTypeService pts (nolock) on s.ServiceKey = pts.ServiceKey
	Where
		pts.ProjectTypeKey = @ProjectTypeKey
	Order By s.Description
GO
