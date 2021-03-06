USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xIDAL_Xfer_DeleteProject]    Script Date: 12/21/2015 13:36:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xIDAL_Xfer_DeleteProject] @project char(16)
AS

	delete 
		xIDAL_XFerFrom
	where 
		project = @project

	delete 
		xIDAL_XFerTo
	where 
		From_project = @project
GO
