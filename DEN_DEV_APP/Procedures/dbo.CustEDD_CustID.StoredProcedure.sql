USE [DEN_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustEDD_CustID]    Script Date: 12/21/2015 14:05:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustEDD_CustID] @parm1 varchar(15), @parm2 varchar(2)
AS
	SELECT *
	FROM CustEDD
	WHERE CustID = @parm1 AND DocType like @parm2
	ORDER BY CustID, DocType
GO
