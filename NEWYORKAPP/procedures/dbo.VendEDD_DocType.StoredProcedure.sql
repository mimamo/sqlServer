USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[VendEDD_DocType]    Script Date: 12/21/2015 16:01:21 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[VendEDD_DocType] @parm1 varchar(2)
AS
	SELECT *
	FROM VendEDD
	WHERE DocType = @parm1
	ORDER BY DocType
GO
