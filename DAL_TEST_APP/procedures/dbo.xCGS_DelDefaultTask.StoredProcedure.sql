USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_DelDefaultTask]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xCGS_DelDefaultTask] @DefaultType char(30), @pjt_entity char(30) AS

	DELETE FROM xCGS_PJPENTEX WHERE DefaultType = @DefaultType and pjt_entity = @pjt_entity
	DELETE FROM xCGS_PJPENT WHERE DefaultType = @DefaultType and pjt_entity = @pjt_entity
GO
