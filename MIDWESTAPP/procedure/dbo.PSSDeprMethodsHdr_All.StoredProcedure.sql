USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSDeprMethodsHdr_All]    Script Date: 12/21/2015 15:55:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSDeprMethodsHdr_All] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSDeprMethodsHdr WHERE DeprMethod LIKE @parm1 ORDER BY DeprMethod
GO
