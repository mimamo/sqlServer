USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_CusRef_INDMFI_D]    Script Date: 12/21/2015 15:55:48 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDARDoc_CusRef_INDMFI_D]
	@CustID		varchar(15),
	@RefNbr		varchar(10)
AS
SELECT * FROM ARDoc
WHERE CustID = @CustID and DocType IN ('IN', 'DM', 'FI') and OpenDoc = 1 and RefNbr LIKE @RefNbr
ORDER BY RefNbr DESC
GO
