USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Ed850LDisc_LineNbr]    Script Date: 12/16/2015 15:55:19 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Ed850LDisc_LineNbr] @parm1 varchar(15)  As Select * from Ed850LDisc where EDIPOID = @parm1 order by LineNbr
GO
