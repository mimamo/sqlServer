USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDTaxPmt_Code]    Script Date: 12/21/2015 15:55:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDTaxPmt_Code] @parm1 varchar(5) AS
  Select * from XDDTaxPmt where
  Selected = 'Y' and
  Code LIKE @parm1
  Order by Code, SubCategory
GO
