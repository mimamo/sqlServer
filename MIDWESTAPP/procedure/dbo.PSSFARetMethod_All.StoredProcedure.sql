USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSFARetMethod_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSFARetMethod_All] @parm1 VARCHAR(10) AS
  SELECT * FROM PSSFARetMethod WHERE RetireMethod = @parm1 ORDER BY RetireMethod
GO
