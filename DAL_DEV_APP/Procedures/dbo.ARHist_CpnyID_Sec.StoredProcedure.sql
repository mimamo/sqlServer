USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[ARHist_CpnyID_Sec]    Script Date: 12/21/2015 13:35:36 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[ARHist_CpnyID_Sec] @parm1 varchar ( 15), @parm2 varchar ( 4),  @parm3 varchar(47), @parm4 varchar(7), @parm5 varchar(1)
WITH EXECUTE AS '07718158D19D4f5f9D23B55DBF5DF1'
as
       Select * from ARHist
           where CustId = @parm1
             and FiscYr = @parm2
             and Cpnyid in

(select Cpnyid
 from vs_share_usercpny
   where userid = @parm3
   and scrn = @parm4
   and seclevel >= @parm5)

           order by CustId, FiscYr
GO
