USE [DAL_TEST_APP]
GO
/****** Object:  StoredProcedure [dbo].[APDoc_DocClass_RefNbr]    Script Date: 12/21/2015 13:56:52 ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
/****** Object:  Stored Procedure dbo.APDoc_DocClass_RefNbr    Script Date: 4/7/98 12:19:54 PM ******/
Create Procedure [dbo].[APDoc_DocClass_RefNbr] @parm1 varchar ( 1), @parm2 varchar ( 10) as
Select * from APDoc where DocClass = @parm1
and RefNbr like @parm2 order by DocClass, RefNbr
GO
