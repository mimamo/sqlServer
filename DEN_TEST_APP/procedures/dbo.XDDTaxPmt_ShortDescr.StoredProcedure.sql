USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTaxPmt_ShortDescr]    Script Date: 12/21/2015 15:37:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTaxPmt_ShortDescr]
  @parm1   varchar(15)

AS
  Select   *
  FROM     XDDTaxPmt
  WHERE    ShortDescr LIKE @parm1
  Order by ShortDescr
GO
