USE [DAL_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_Location]    Script Date: 12/21/2015 13:35:38 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_Location    Script Date: 4/17/98 10:58:17 AM ******/
/****** Object:  Stored Procedure dbo.Delete_Location    Script Date: 4/16/98 7:41:51 PM ******/
Create Proc [dbo].[Delete_Location] @parm1 varchar ( 30) as
    Delete location from Location where
                InvtId = @parm1 and
                QtyOnHand = 0.00 and
                QtyAlloc = 0.00
GO
