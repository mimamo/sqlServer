USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAutoLimits_All]    Script Date: 12/21/2015 13:45:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAutoLimits_All] @parm1 VARCHAR(15) AS
  SELECT * FROM PSSFAAutoLimits WHERE VehicleType LIKE @parm1 ORDER BY VehicleType
GO
