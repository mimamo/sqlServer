USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_XFerTo_SelectProject]    Script Date: 12/21/2015 13:45:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_XFerTo_SelectProject] 
			@FromProject char(16),
			@project char(16),
			@pjt_entity char(32)
AS
	SELECT *
	from 
		xIDAL_XFerTo
	where 
		From_project = @FromProject and
		project = @project and
		pjt_entity like @pjt_entity
	order by
		From_project ,
		Project,
		pjt_entity
GO
