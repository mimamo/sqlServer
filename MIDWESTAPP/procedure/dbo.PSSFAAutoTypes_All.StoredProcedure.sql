USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFAAutoTypes_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFAAutoTypes_All] @parm1 VARCHAR(15) AS
  SELECT * FROM PSSFAAutoTypes WHERE VehicleType LIKE @parm1 ORDER BY VehicleType
GO
