USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[vb08240_Max_perappl]    Script Date: 12/21/2015 16:13:27 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.vb08240_Max_perappl    Script Date: 11/29/00 12:30:33 PM ******/
CREATE PROC [dbo].[vb08240_Max_perappl] @parm1 varchar(15), @parm2 varchar (2), @parm3 varchar(10) AS
SELECT MAX(perappl)
  FROM aradjust
 WHERE CustID = @parm1
   AND AdjgDoctype = @parm2
   AND Adjgrefnbr = @parm3
GO
