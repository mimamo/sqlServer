USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceClassesAR_Descr]    Script Date: 12/16/2015 15:55:30 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PriceClassesAR_Descr] @parm1 varchar (6) as
    Select Descr from PriceClass where PriceClassID = @parm1 and PriceClassType = "C" order by PriceClassType, PriceClassid
GO
