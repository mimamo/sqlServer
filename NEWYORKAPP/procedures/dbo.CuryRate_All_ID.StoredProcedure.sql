USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[CuryRate_All_ID]    Script Date: 12/21/2015 16:00:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.CuryRate_All_ID    Script Date: 4/7/98 12:43:41 PM ******/
Create Proc [dbo].[CuryRate_All_ID] @parm1 varchar ( 4), @parm2 varchar ( 4), @parm3 varchar ( 6), @parm4beg smalldatetime, @parm4end smalldatetime as
    Select * from CuryRate
    where FromCuryId like @parm1
    and   ToCuryId like @parm2
    and   RateType like @parm3
    and   Effdate between @parm4beg and @parm4end
    order by FromCuryId, ToCuryId, RateType, EffDate DESC
GO
