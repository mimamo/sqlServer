USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustEDD_DocType]    Script Date: 12/21/2015 16:06:59 ******/
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
