USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Kit_Kitid_Site53]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
Create Proc [dbo].[Kit_Kitid_Site53] @parm1 varchar ( 30), @parm2 varchar ( 10) as
        Select * from Kit where
        	Kitid like @parm1 and
		Siteid like @parm2 and
		Status <> 'O' and
		KitType = 'B'
        Order by Kitid, Siteid, Status
GO
