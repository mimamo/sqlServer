USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_CustID_RefNbr_CM_D]    Script Date: 12/16/2015 15:55:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDARDoc_CustID_RefNbr_CM_D]
	@CustID		varchar(15),
	@RefNbr		varchar(10)
AS
SELECT * FROM ARDoc
WHERE CustID = @CustID and DocType = 'CM' and OpenDoc = 1 and RefNbr LIKE @RefNbr
ORDER BY RefNbr DESC
GO
