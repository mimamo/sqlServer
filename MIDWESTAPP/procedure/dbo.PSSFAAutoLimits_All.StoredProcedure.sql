USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAutoLimits_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAutoLimits_All] @parm1 VARCHAR(15) AS
  SELECT * FROM PSSFAAutoLimits WHERE VehicleType LIKE @parm1 ORDER BY VehicleType
GO
