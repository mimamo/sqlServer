USE [DEN_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[List_ListID]    Script Date: 12/21/2015 15:36:59 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.List_ListID    Script Date: 4/17/98 12:50:25 PM ******/
/****** Object:  Stored Procedure dbo.List_ListID    Script Date: 4/7/98 12:51:20 PM ******/
Create Proc [dbo].[List_ListID] @parm1 varchar ( 40) as
       Select * from List
           where ListID  LIKE  @parm1
           order by ListID
GO
