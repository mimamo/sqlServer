USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_SelectProject]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_SelectProject] @project char(16),  @pjt_entity char(16)
AS
	SELECT *
	from 
		xtmpAPSXfer
	where 
		studio_project = @project and
		studio_pjt_entity like @pjt_entity
	order by
		studio_project,
		studio_pjt_entity
GO
