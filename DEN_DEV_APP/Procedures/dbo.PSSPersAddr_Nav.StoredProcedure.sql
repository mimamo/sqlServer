USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSPersAddr_Nav]    Script Date: 12/21/2015 14:06:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSPersAddr_Nav] 
  @parm1 varchar(10), @parm2min smallint, @parm2max smallint As
  Select * from PSSPersAddr 
  where ClientCode = @parm1
  and LineId between @parm2min and @parm2max
  order by LineId
GO
