USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTaxPmt_Code_SubCat]    Script Date: 12/16/2015 15:55:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTaxPmt_Code_SubCat]
  @parm1 varchar(5),
  @parm2 varchar(5),
  @parm3 varchar(15)

AS

  Select    *
  FROM      XDDTaxPmt
  WHERE     Code LIKE @parm1 and
            SubCategory LIKE @parm2 and
            IDNbr LIKE @parm3
  Order by  Code, SubCategory, IDNbr
GO
