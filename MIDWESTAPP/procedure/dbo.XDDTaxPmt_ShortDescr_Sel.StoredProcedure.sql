USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTaxPmt_ShortDescr_Sel]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTaxPmt_ShortDescr_Sel]
  @parm1   varchar(15)

AS
  Select   *
  FROM     XDDTaxPmt
  WHERE    ShortDescr LIKE @parm1
           and Selected = 'Y'
  Order by ShortDescr
GO
