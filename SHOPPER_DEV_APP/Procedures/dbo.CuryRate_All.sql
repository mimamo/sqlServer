USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[CuryRate_All]    Script Date: 12/16/2015 15:55:15 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryRate_All    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CuryRate_All] as
    Select * from CuryRate
    order by FromCuryId DESC, ToCuryId DESC, RateType DESC, EffDate DESC
GO
