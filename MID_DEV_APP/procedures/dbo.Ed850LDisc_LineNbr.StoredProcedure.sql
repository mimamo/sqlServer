USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850LDisc_LineNbr]    Script Date: 12/21/2015 14:17:41 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Ed850LDisc_LineNbr] @parm1 varchar(15)  As Select * from Ed850LDisc where EDIPOID = @parm1 order by LineNbr
GO
