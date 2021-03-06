USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[xtmpAPSXfer_SelectAgencyProject]    Script Date: 12/21/2015 14:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xtmpAPSXfer_SelectAgencyProject] 
			@studio_project char(16),
			@agency_project char(16),
			@agency_pjt_entity varchar(32)
AS
	SELECT *
	from 
		xtmpAPSXferAgency
	where 
		studio_project = @studio_Project and
		agency_project = @agency_project and
		agency_pjt_entity like @agency_pjt_entity
	order by
		studio_project,
		agency_Project,
		agency_pjt_entity
GO
