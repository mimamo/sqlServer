USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_SOAddress]    Script Date: 12/16/2015 15:55:16 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_SOAddress    Script Date: 4/7/98 12:30:33 PM ******/
Create Proc [dbo].[Delete_SOAddress] @parm1 varchar(15) as
    Delete from SOAddress where CustID = @parm1
GO
