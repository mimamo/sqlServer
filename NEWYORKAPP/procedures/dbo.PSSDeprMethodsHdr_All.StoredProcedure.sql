USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[PSSDeprMethodsHdr_All]    Script Date: 12/21/2015 16:01:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[PSSDeprMethodsHdr_All] @parm1 VARCHAR(20) AS
  SELECT * FROM PSSDeprMethodsHdr WHERE DeprMethod LIKE @parm1 ORDER BY DeprMethod
GO
