USE [MID_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[VendEDDReceiver_VendID]    Script Date: 12/21/2015 15:49:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[VendEDDReceiver_VendID] @parm1 varchar(15), @parm2 varchar(2)  
AS  
	SELECT *  
	FROM VendEDDReceiver  
	WHERE VendID = @parm1 AND DocType like @parm2  
	ORDER BY VendID, DocType
GO
