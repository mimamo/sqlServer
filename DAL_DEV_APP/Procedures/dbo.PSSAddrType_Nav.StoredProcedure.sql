USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAddrType_Nav]    Script Date: 12/21/2015 13:35:52 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSAddrType_Nav] @parm1min smallint, @parm1max smallint As
  Select * From PSSAddrType where lineid between @parm1min and @parm1max order by Lineid
GO
