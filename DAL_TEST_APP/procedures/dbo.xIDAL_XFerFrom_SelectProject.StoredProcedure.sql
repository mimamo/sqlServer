USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_XFerFrom_SelectProject]    Script Date: 12/21/2015 13:57:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_XFerFrom_SelectProject] @project char(16),  @pjt_entity char(16)
AS
	SELECT *
	from 
		xIDAL_XFerFrom
	where 
		project = @project and
		pjt_entity like @pjt_entity
	order by
		project,
		pjt_entity
GO
