USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_RefNbr_All_D]    Script Date: 12/21/2015 13:45:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDARDoc_RefNbr_All_D]
	@RefNbr		varchar(10)
AS
SELECT * FROM ARDoc WHERE RefNbr LIKE @RefNbr ORDER BY RefNbr DESC
GO
