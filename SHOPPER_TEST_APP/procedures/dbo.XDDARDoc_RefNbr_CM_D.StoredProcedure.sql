USE [SHOPPER_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[XDDARDoc_RefNbr_CM_D]    Script Date: 12/21/2015 16:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
create proc [dbo].[XDDARDoc_RefNbr_CM_D]
	@RefNbr		varchar(10)
AS
SELECT * FROM ARDoc WHERE DocType = 'CM' and OpenDoc = 1 and RefNbr LIKE @RefNbr ORDER BY RefNbr DESC
GO
