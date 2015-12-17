USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[EDInbound_850875ConvMeth]    Script Date: 12/16/2015 15:55:20 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[EDInbound_850875ConvMeth] @Parm1 varchar(15) As Select ConvMeth From EDInbound
Where CustId = @Parm1 And Trans In ('850','875') Order By CustId, Trans
GO
