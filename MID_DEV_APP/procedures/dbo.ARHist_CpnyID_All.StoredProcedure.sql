USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CpnyID_All]    Script Date: 12/21/2015 14:17:33 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARHist_CpnyID_All    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARHist_CpnyID_All] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 4) as
       Select * from ARHist
           where CustId like @parm1
             and CpnyID Like @parm2
             and FiscYr like @parm3
           order by CustId, FiscYr
GO
