USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAPJProj_All]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAPJProj_All] @parm1 VARCHAR(30) AS
  SELECT * FROM PSSFAPJProj WHERE Project LIKE @parm1 ORDER BY Project
GO
