USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSDeprSect_All]    Script Date: 12/21/2015 14:17:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSDeprSect_All] @parm1 VARCHAR(6) AS
  SELECT * FROM PSSDeprSect WHERE Sect Like @parm1 ORDER BY Sect
GO
