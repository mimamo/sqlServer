USE [MIDWESTAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CustId_FiscYr1_CpnyID]    Script Date: 12/21/2015 15:55:22 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARHist_CustId_FiscYr1_CpnyID    Script Date: 4/7/98 12:30:33 PM ******/
Create Procedure [dbo].[ARHist_CustId_FiscYr1_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    select * from ARHist where CustId = @parm1
    and CpnyID = @parm2
    and FiscYr >= @parm3
    order by CustId, FiscYr
GO
