USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendEDD_DocType]    Script Date: 12/16/2015 15:55:36 ******/
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
