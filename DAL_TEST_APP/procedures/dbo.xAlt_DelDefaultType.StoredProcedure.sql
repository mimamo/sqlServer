USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xAlt_DelDefaultType]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xAlt_DelDefaultType] @DefaultType char(30) AS

	DELETE FROM xALT_PJPENTEX WHERE DefaultType = @DefaultType
	DELETE FROM xALT_PJPENT WHERE DefaultType = @DefaultType
	DELETE FROM xALT_PJADDR WHERE DefaultType = @DefaultType
	DELETE FROM xALT_PJBILL WHERE DefaultType = @DefaultType
	DELETE FROM xALT_PJPROJEX WHERE DefaultType = @DefaultType
	DELETE FROM xALT_PJPROJ WHERE DefaultType = @DefaultType
GO
