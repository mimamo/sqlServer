USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Cash_Docs]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create proc [dbo].[Cash_Docs] @parm1 varchar (10), @parm2 varchar (10), @parm3 varchar (15) AS
SELECT * FROM ARDoc
WHERE batnbr = @parm1 AND (refnbr <> @parm2 or custid <> @parm3) and doctype IN ('PA','PP')
GO
