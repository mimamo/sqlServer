USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[PriceClassesAR_Descr]    Script Date: 12/21/2015 13:57:11 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[PriceClassesAR_Descr] @parm1 varchar (6) as
    Select Descr from PriceClass where PriceClassID = @parm1 and PriceClassType = "C" order by PriceClassType, PriceClassid
GO
