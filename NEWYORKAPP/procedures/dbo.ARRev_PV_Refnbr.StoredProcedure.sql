USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[ARRev_PV_Refnbr]    Script Date: 12/21/2015 16:00:49 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.ARRev_PV_Refnbr    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[ARRev_PV_Refnbr] @parm1 varchar(10), @parm2 varchar(10) AS

Select * from ARDoc Where CpnyId = @parm1
and refnbr like @parm2
and doctype in ('PA', 'CM')
and Rlsed = 1
and noprtstmt = 0
Order by Refnbr
GO
