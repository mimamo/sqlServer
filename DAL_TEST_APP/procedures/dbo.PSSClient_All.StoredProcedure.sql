USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PSSClient_All]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--APPTABLE
CREATE PROCEDURE [dbo].[PSSClient_All] 
  @parm1 varchar(10) As
  Select * from PSSClient 
  where ClientCode like @parm1 
  order by ClientCode
GO
