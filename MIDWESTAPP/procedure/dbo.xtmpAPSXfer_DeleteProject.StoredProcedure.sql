USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_DeleteProject]    Script Date: 12/21/2015 15:55:50 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_DeleteProject] @project char(16)
AS

	delete 
		xtmpAPSXfer
	where 
		studio_project = @project

	delete 
		xtmpAPSXferAgency
	where 
		studio_project = @project
GO
