USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSAddrCode_All]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSAddrCode_All] @parm1 varchar(15) As
  Select * from PSSAddrCode where AddrCode like @parm1 order by AddrCode
GO
