USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDLBView_CustOrdNbr_PV]    Script Date: 12/21/2015 14:34:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDLBView_CustOrdNbr_PV]
	@CustOrdNbr		varchar(25)
AS
	SELECT * FROM ARDoc
	WHERE CustOrdNbr <> ''
 	and DocType IN ('IN', 'DM') 
 	and CustOrdNbr LIKE @CustOrdNbr
	ORDER BY CustOrdNbr
GO
