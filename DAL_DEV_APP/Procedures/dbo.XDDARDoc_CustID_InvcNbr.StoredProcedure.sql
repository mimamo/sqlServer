USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_CustID_InvcNbr]    Script Date: 12/21/2015 13:35:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[XDDARDoc_CustID_InvcNbr]
	@CustID		varchar(15),
	@InvcNbr	varchar(10)
AS

	SELECT		* 
	FROM		ARDoc (nolock)
	WHERE		CustID = @CustID
			and RefNbr LIKE @InvcNbr
			and DocType IN ('IN', 'DM', 'FI')
GO
