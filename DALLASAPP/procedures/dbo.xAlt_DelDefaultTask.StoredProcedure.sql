USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_DelDefaultTask]    Script Date: 12/21/2015 13:45:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_DelDefaultTask] @DefaultType char(30), @pjt_entity char(30) AS

	DELETE FROM xALT_PJPENTEX WHERE DefaultType = @DefaultType and pjt_entity = @pjt_entity
	DELETE FROM xALT_PJPENT WHERE DefaultType = @DefaultType and pjt_entity = @pjt_entity
GO
