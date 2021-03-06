USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[xCGS_DelDefaultType]    Script Date: 12/21/2015 13:57:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[xCGS_DelDefaultType] @DefaultType char(30) AS

	DELETE FROM xCGS_PJPENTEX WHERE DefaultType = @DefaultType
	DELETE FROM xCGS_PJPENT WHERE DefaultType = @DefaultType
	DELETE FROM xCGS_PJADDR WHERE DefaultType = @DefaultType
	DELETE FROM xCGS_PJBILL WHERE DefaultType = @DefaultType
	DELETE FROM xCGS_PJPROJEX WHERE DefaultType = @DefaultType
	DELETE FROM xCGS_PJPROJ WHERE DefaultType = @DefaultType
GO
