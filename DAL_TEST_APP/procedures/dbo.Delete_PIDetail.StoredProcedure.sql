USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[Delete_PIDetail]    Script Date: 12/21/2015 13:56:56 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.Delete_PIDetail    Script Date: 4/17/98 10:58:17 AM ******/
Create Proc [dbo].[Delete_PIDetail] @parm1 VarChar(6) as
    Delete from PIDetail where PerClosed <= @parm1
GO
