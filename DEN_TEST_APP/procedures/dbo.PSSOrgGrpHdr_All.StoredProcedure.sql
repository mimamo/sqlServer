USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSOrgGrpHdr_All]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSOrgGrpHdr_All] 
  @parm1 varchar(10) As
  Select * from PSSOrgGrpHdr 
  where OrgCode like @parm1 
  order by OrgCode
GO
