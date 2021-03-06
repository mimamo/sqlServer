USE [SHOPPERAPP]
GO
/****** Object:  StoredProcedure [dbo].[CuryRate_ID_Date]    Script Date: 12/21/2015 16:13:05 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryRate_ID_Date    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CuryRate_ID_Date] @parm1 varchar ( 4), @parm2 varchar ( 4), @parm3 varchar ( 6), @parm4 smalldatetime as
    Select * from CuryRate
        where FromCuryId like @parm1
        and ToCuryId like @parm2
        and RateType like @parm3
        and EffDate <= @parm4
    order by FromCuryId DESC, ToCuryId DESC, RateType DESC, EffDate DESC
GO
