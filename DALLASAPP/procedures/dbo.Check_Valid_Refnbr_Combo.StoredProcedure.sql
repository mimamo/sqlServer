USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Check_Valid_Refnbr_Combo]    Script Date: 12/21/2015 13:44:47 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Check_Valid_Refnbr_Combo    Script Date: 11/29/00 12:30:33 PM ******/
CREATE PROC [dbo].[Check_Valid_Refnbr_Combo] @parm1 varchar(15), @parm2 varchar (2), @parm3 varchar(10) AS
SELECT *
  FROM ARDoc
 WHERE CustID = @parm1
   AND Doctype = @parm2
   AND refnbr = @parm3
GO
