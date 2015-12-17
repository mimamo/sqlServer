USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendEDD_VendID]    Script Date: 12/16/2015 15:55:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[VendEDD_VendID] @parm1 varchar(15), @parm2 varchar(2)
AS
	SELECT *
	FROM VendEDD
	WHERE VendID = @parm1 AND DocType like @parm2
	ORDER BY VendID, DocType
GO
