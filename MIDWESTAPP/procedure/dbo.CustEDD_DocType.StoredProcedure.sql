USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[CustEDD_DocType]    Script Date: 12/21/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustEDD_DocType] @parm1 varchar(2)
AS
	SELECT *
	FROM CustEDD
	WHERE DocType = @parm1
	ORDER BY DocType
GO
