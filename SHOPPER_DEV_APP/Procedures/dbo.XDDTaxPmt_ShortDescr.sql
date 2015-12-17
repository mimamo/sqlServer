USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTaxPmt_ShortDescr]    Script Date: 12/16/2015 15:55:38 ******/
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
