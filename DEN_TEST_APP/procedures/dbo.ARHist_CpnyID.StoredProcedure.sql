USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CpnyID]    Script Date: 12/21/2015 15:36:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARHist_CpnyID    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARHist_CpnyID] @parm1 varchar ( 15), @parm2 varchar ( 4), @parm3 varchar ( 10) as
       Select * from ARHist
           where CustId like @parm1
             and Fiscyr Like @parm2
             and CpnyID like @parm3
           order by CustId, FiscYr
GO
