USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSPersRelP_Nav]    Script Date: 12/21/2015 15:37:06 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSPersRelP_Nav] 
  @parm1 varchar(10), @parm2min smallint, @parm2max smallint As
  Select * from PSSPersRelP
where  PSSPersRelP.PersonCode = @parm1
and PSSPersRelP.LineId between @parm2min and @parm2max
GO
