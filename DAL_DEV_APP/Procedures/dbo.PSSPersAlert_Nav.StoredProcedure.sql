USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSPersAlert_Nav]    Script Date: 12/21/2015 13:35:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSPersAlert_Nav] 
  @parm1 varchar(10), @parm2min smallint, @parm2max smallint As
  Select * from PSSPersAlert 
  where PersonCode = @parm1
  and LineId between @parm2min and @parm2max
  order by PlsBeAwareDate desc
GO
