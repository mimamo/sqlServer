USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_ConvMeth_UTP]    Script Date: 12/21/2015 13:57:01 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROC [dbo].[EDOutbound_ConvMeth_UTP]
	@CustId varchar(15),
	@Trans varchar(3)
As
	SELECT ConvMeth, S4Future09
	FROM EDOutbound
	WHERE CustId = @CustId And Trans = @Trans
GO
