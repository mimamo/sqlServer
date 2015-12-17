USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDBatchARLBApplic_DocType_RefNbr]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDBatchARLBApplic_DocType_RefNbr]
	@PmtRecordID	int,
	@DocType	varchar(2),
	@RefNbr		varchar(10)
	
AS
	SELECT		*
	FROM		XDDBatchARLBApplic (nolock)
	WHERE		PmtRecordID = @PmtRecordID
			and DocType = @DocType
			and RefNbr = @RefNbr
GO
