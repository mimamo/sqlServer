USE [SHOPPER_DEV_APP]
GO
/****** Object:  StoredProcedure [dbo].[List_DEL_ListID]    Script Date: 12/16/2015 15:55:24 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.List_DEL_ListID    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.List_DEL_ListID    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc [dbo].[List_DEL_ListID] @parm1 varchar ( 40) as
       Delete list from List
           where ListID  LIKE  @parm1
GO
