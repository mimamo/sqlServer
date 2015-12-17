USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CustId_FiscYr1_CpnyID1]    Script Date: 12/16/2015 15:55:13 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARHist_CustId_FiscYr1_CpnyID1    Script Date: 11/13/98 12:30:33 PM ******/
Create Procedure [dbo].[ARHist_CustId_FiscYr1_CpnyID1] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 4) as
    select * from ARHist where CustId = @parm1
    and CpnyID = @parm2
    and FiscYr = @parm3
    order by CustId, FiscYr
GO
