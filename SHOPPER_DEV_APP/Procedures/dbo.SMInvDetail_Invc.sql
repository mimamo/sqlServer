USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[SMInvDetail_Invc]    Script Date: 12/16/2015 15:55:34 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[SMInvDetail_Invc]
	@parm1 varchar(10),
	@parm2 varchar(10)
AS
	SELECT * FROM SMInvDetail
	WHERE 	Refnbr = @parm1 and DocumentID = @parm2
	ORDER BY refnbr, DocumentID, LineID
GO
