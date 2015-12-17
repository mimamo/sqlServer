USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Location_Invtid_Siteid_BOM]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Location_Invtid_Siteid_BOM    Script Date: 4/17/98 10:58:18 AM ******/
/****** Object:  Stored Procedure dbo.Location_Invtid_Siteid_BOM    Script Date: 4/16/98 7:41:52 PM ******/
Create Proc [dbo].[Location_Invtid_Siteid_BOM] @parm1 varchar ( 30), @parm2 varchar ( 10) as
Select * from location where invtid = @parm1 and siteid like @parm2 order by
        invtid, siteid, whseloc
GO
