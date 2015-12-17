USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDOutbound_ConvMeth_UTP]    Script Date: 12/16/2015 15:55:21 ******/
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
