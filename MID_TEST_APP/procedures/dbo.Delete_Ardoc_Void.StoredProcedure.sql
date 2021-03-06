USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Ardoc_Void]    Script Date: 12/21/2015 15:49:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_ARdoc_Void    Script Date: 01/31/00 ******/
CREATE PROC [dbo].[Delete_Ardoc_Void] @parm1 VARCHAR (15), @parm2 VARCHAR (2), @parm3 VARCHAR (10), @Parm4 VARCHAR(10) AS
DELETE  ARDoc
	FROM ARDoc
	WHERE
             ARDoc.CustId  = @parm1  and
             ARDoc.DocType = @parm2 and
       	     ARDoc.RefNbr  = @parm3  and
             ARDoc.Batnbr  = @Parm4
GO
