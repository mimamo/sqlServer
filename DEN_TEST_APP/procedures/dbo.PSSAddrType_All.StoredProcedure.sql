USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAddrType_All]    Script Date: 12/21/2015 15:37:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSAddrType_All] @parm1 varchar(10) As
  Select * from PSSAddrType where AddrTypeCode like @parm1 order by AddrTypeCode
GO
