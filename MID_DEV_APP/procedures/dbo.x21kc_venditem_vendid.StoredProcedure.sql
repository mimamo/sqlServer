USE [MID_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[x21kc_venditem_vendid]    Script Date: 12/21/2015 14:18:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE proc [dbo].[x21kc_venditem_vendid] @parm1 varchar (15), @parm2 varchar (30), @parm3 varchar (4)  as
	select  * from venditem where
	vendid = @parm1
	and invtid = @parm2
	and fiscyr = @parm3
	order by  vendid
GO
