USE [NEWYORKAPP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_Stat_Ln3]    Script Date: 12/21/2015 16:00:51 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Comp_Kit_Site_Stat_Ln3] @parm1 varchar (30),@parm2 varchar (10),
        @parm3 varchar (1), @parm4 varchar (10), @parm5beg smallint,@parm5end smallint as
        Select * from Component where
        Kitid = @parm1 and KitSiteid = @parm2
        and kitstatus = @parm3 and siteid = @parm4
	and linenbr between @parm5beg and @parm5end
        Order by Kitid,Kitsiteid, Kitstatus,Linenbr,Cmpnentid
GO
