USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSLILetterCode_All]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSLILetterCode_All] @parm1 varchar(10) As
  Select * from PSSLILetterCode where LetterCode like @parm1 order by LetterCode
GO
