USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_DeleteProject]    Script Date: 12/16/2015 15:55:39 ******/
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
