USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[CustEDDReceiver_CustID]    Script Date: 12/21/2015 16:06:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[CustEDDReceiver_CustID] @parm1 varchar(15), @parm2 varchar(2)  
AS  
	SELECT *  
	FROM CustEDDReceiver  
	WHERE CustID = @parm1 AND DocType like @parm2  
	ORDER BY CustID, DocType
GO
