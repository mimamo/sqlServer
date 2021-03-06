USE [DALLASAPP]
GO
/****** Object:  StoredProcedure [dbo].[Comp_Kit_Site_Stat_Ln2]    Script Date: 12/21/2015 13:44:48 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Comp_Kit_Site_Stat_Ln2    Script Date: 4/17/98 12:19:28 PM ******/
Create Proc [dbo].[Comp_Kit_Site_Stat_Ln2] @parm1 varchar ( 30),@parm2 varchar ( 10),
        @parm3 varchar ( 1),@parm4beg smallint,@parm4end smallint as
        Select * from Component where
        Kitid = @parm1 and KitSiteid = @parm2
        and kitstatus = @parm3 and linenbr between
        @parm4beg and @parm4end
        Order by Kitid,Kitsiteid,Kitstatus,LineNbr,Cmpnentid
GO
