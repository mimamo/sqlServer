USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_BatNbr_CustId_RefNbr]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDARDoc_BatNbr_CustId_RefNbr]
	@BatNbr			varchar(10),
	@CustID			varchar(15),
	@RefNbr			varchar(10),
	@Doctype		varchar(2)
AS	
	SELECT		* 
	FROM		ARDoc (nolock)
	WHERE		BatNbr = @BatNbr
		        and CustId = @CustID
		        and RefNbr = @RefNbr
		        and DocType = @DocType
GO
