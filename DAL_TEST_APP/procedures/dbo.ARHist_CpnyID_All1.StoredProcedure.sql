USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CpnyID_All1]    Script Date: 12/21/2015 13:56:53 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE Proc [dbo].[ARHist_CpnyID_All1] @parm1 varchar ( 15), @parm2 varchar ( 10), @parm3 varchar ( 4) as
       Select * from ARHist
           where CustId like @parm1
             and (CpnyID Like @parm2 or @parm2 ='')
             and FiscYr like @parm3
           order by CustId, FiscYr
GO
