USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[WrkFSTriBal_DEL_RefNbr]    Script Date: 12/21/2015 13:57:18 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.WrkFSTriBal_DEL_RefNbr    Script Date: 4/7/98 12:45:04 PM ******/
Create Proc [dbo].[WrkFSTriBal_DEL_RefNbr] @parm1 varchar (10) As
     Delete from WrkFSTriBal
     Where RefNbr = @parm1
GO
