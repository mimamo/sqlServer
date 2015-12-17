USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CpnyID_All1]    Script Date: 12/16/2015 15:55:13 ******/
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
