USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSOrgGrpDet_All]    Script Date: 12/21/2015 13:57:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSOrgGrpDet_All] @parm1 varchar(10), @Parm2 varchar(50) As
  Select * from PSSOrgGrpDet where OrgCode = @parm1 and PersonCode Like @Parm2 order by PersonCode
GO
