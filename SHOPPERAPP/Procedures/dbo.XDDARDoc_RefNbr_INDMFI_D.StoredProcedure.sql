USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_RefNbr_INDMFI_D]    Script Date: 12/21/2015 16:13:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDARDoc_RefNbr_INDMFI_D]
	@RefNbr		varchar(10)
AS
SELECT * FROM ARDoc WHERE DocType IN ('IN', 'DM', 'FI') and OpenDoc = 1 and RefNbr LIKE @RefNbr ORDER BY RefNbr DESC
GO
